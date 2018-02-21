---
title:      Analysis of SSHFS performance for large builds
date:       2016-02-17 08:30:00 -0500
categories:
  - "software"
excerpt_separator: <!--end-of-excerpt-->
---

Last week, I spent some time looking at the **feasibility of using SSHFS on OS X to access Google's centralized source tree for the purpose of issuing local builds**. My goals were two-fold: first, to **avoid having to "clone" the large source code** of the apps I wanted to build; and, second, to **avoid having to port** the source file system (a FUSE module) to the Mac.

What I found highlights that **SSHFS is not the right choice for locally building a remote source tree**. That said, the overall study process was interesting, fun, and I am now tempted to make SSHFS viable for this use case. Read on for the details.

<!--end-of-excerpt-->

*Obligatory disclaimer:* There is not much specific to Google here and any opinions are my own. In fact, I had used SSHFS in the past for similar purposes: to expose a NetBSD source tree from the host machine to a VM running on it, using the virtual network interface. Knowing these details at the time would have been very helpful in understanding the behavior of the setup.

# The source file system

The Google source tree is exposed to developer machines by a FUSE file system that exposes the (very) large centralized repository at any desired revision; think of paths of the form `.../src/<revision>/`. Let's call this FUSE file system the **source file system**, about which you can learn more in the [Build in the cloud: Accessing source code](http://google-engtools.blogspot.com/2011/06/build-in-cloud-accessing-source-code.html) blog post and in the following presentation:

<div class="frame">
  <div class="content">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/b52aXZ2yi08" frameborder="0" allowfullscreen></iframe>
  </div>
  <div class="footer">
    <p>Tools for Continuous Integration at Google Scale.</p>
  </div>
</div>

The key characteristics, for the understanding of this article, of the source file system are:

* The file system contents under a given revision are read-only.

* Because the file system is read-only, the FUSE server implements aggressive caching of file metadata and contents.

* Because the file system is read-only, and due to the way the repository data is stored internally, each file holds an extended attribute that exposes its MD5 digest in constant time. This allows the build system to quickly determine if a file has changed across builds.

If this sounds interesting, there is a similar filesystem in spirit available in GitHub under the [hanwen/p4fuse](https://github.com/hanwen/p4fuse) repository.

# Experimental setup

In order to quantify if the source file system mounted over SSHFS is a workable environment for large builds, I tested various configurations and measured the build times of different iOS applications.

In particular, I used the following configurations:

* **Source file system over SSHFS**: This configuration mounts the source tree directly on SSHFS. There is no local persistent caching of data; only whatever SSHFS's cache does (more on this important topic below).

* **Souce file system over SSHFS with a [pCacheFS](https://github.com/ibizaman/pcachefs) layer on top**: This configuration mounts the remote source tree onto a `.../src-remote/` directory and then layers pCacheFS on top of it to offer the actual `.../src/` directory. This setup offers persistent caching of the contents of all source files accessed durng the build, and those are stored in a matching `.../src-cache/` directory.

In the text below, the **local machine** is always the OS X system; the **remote machine** (hosting the source file system) is always a Linux machine.

The experiments were done on a *Mac Pro (Late 2013) with a 6-core Intel Xeon X5 CPU @ 3.5 GHz and 32GB of RAM* using a remote Linux workstation of similar hardware. Both machines were physically connected to the same network offering average ping times of 0.5ms and a throughput around 50MB/s for SSH-based file copies. The Linux machine was running OpenSSH 7.1.

# Results

The table below illustrates the time it took to build some iOS apps under the tested configurations. The numbers shown in the tables are the best numbers in multiple runs, some of which involved tweaked versions of both SSHFS and pCacheFS to obtain higher performance from them.

Colums showing *Not tested* are for measurements that were not taken because previous measurements on other configurations showed that they would be worthless: i.e. that no performance gain would be obtained. The SSHFS cold/hot references account for *both* SSHFS and the remote source file system being hot or cold in unison because they are tightly related in the common case.

Target | Local | SSHFS (cold) | SSHFS (hot) | SSHFS+pCacheFS (cold) | SSHFS+pCacheFS (hot)
:--- | ---: | ---: | ---: | ---: | ---:
Small app | 5m | 23m | 6m | 18m | 13m |
Larger app | 5m | 54m | 25m | Not tested | Not tested |

Yes, I only tested two builds because these were enough to yield conclusions. The *Demo app* showed some promising results when the caches were hot, but as soon as I tried a real-world app (the *Larger app*), it became clear that this setup was unfeasible.

As you can see in the table above, the results are disheartening. For the small build, the source file system over SSHFS is a feasible choice assuming the caches are hot. For any larger build, SSHFS introduces a significant performance penalty on the build times. This negative impact does not justify the simplicity of using the SSHFS-based setup and developers should just resort to local checkouts of the parts of the tree they need.

Knowing this, let's move on to the more interesting part of this article, which is all the learnings I got from the file systems implementations and all the tweaks I made in an attempt to obtain higher performance.

## SSHFS observations

* Neither SSHFS, the SFTP protocol, nor the `sshd` daemon support extended attributes. As a consequence, the build system is unable to obtain digests for the source files in constant time. It is unclear if this has a performance impact on the build times themselves because other deficiencies of the system are likely to be the bottleneck.

* The local SSHFS is threaded and will easily consume 1.5 or 2 CPUs during a build. The remote `sshd` server is not threaded for a single SSHFS connection and will continuously consume a full CPU, potentially being the bottleneck.

* A maximum of 3.5 MB/s was observed on the network download link of the OS X workstation when SSHFS was busiest. The fact that the remote `sshd` server was at a peak of 100% CPU usage indicates that the bottleneck was on the server-side SSH connection, not on the SSHFS client nor on the remote FUSE file system. However, it is quite likely, from the following notes on caching, that the SSHFS client was inducing this on itself.

* SSHFS implements caching but neither the `open` nor `read` operations are cached. In fact, SSHFS is only caching directory contents and file attributes. This drops the potential of the cache: remember that the remote source file system is read only.

* SSHFS was modified to never evict anything from its in-memory cache in an attempt to maximize cache hits and thus approach best-case performance. There was no appreciable difference in build times.

* SSHFS was modified to implement caching of file contents for reads. This did not result in any visible performance difference, pointing at the bottleneck being elsewhere as described in the next bullet.

* SSHFS implements caching for `stat` (`getattr` in FUSE terminology), and might be suboptimal. Logging was added to track cache hits for `stat` operations and, out of various thousands of files that were `stat`ed during the build of the *Larger app*, there were several orders of magnitude more `getattr` calls that did not hit the cache. The majority of these duplicate calls were for directories, so it is likely that these operations were not issued by the build system, but instead were issued by SSHFS itself. This is, in all likelihood, the source of contention: all these cache misses incurred a round-trip to the remote `sshd` server and they would explain the high CPU load on the `sshd` server and the low throughput in the network link.

* Repointing the local source tree at a different repository revision blows away any in-memory information cached by SSHFS because the SSHFS cache uses path names as keys. Remember that the revision identifier is part of the `.../src/<revision>/` path.

## pCacheFS observations

* Builds with pCacheFS enabled are not as fast as one would expect, even when the cache is hot. The expectation would be for this scenario to yield build times that are similar to those using local source copies; however, as the numbers above show, build times were twice as large, if not more.

* pCacheFS is written in Python, and this shows: the daemon can only saturate a single CPU, and it does.

* Disk usage in the pCacheFS case is lower than what is required when the source tree is checked out locally. This is expected of any build: the size of the dependencies is larger than the size of the files strictly required for the build. Think about any source package that includes documentation in it, for example.

* pCacheFS does not currently implement the `readlink` call. This call is necessary to properly support the remote source file system: the file system exposes a `.../src/head` symbolic link that points to the head revision. Reading this link is how one determines the revision to access via a `.../src/<revision>/` path for a consistent view of the tree. Implementing this call in pCacheFS should not be difficult, but I did not bother to do so due to the poor performance observed when using this layer.

* pCacheFS is purely read-only and has no cache invalidation. This is not a problem for our use case because the remote source file system is read-only, but highlights that pCacheFS is not usable for the general case.

* As SSHFS, pCacheFS does not implement extended attributes so the same problems apply.

* As SSHFS, pCacheFS uses paths as keys for the cache so repointing the source tree to a different revision blows away the cache.

# Conclusions

Neither the SSHFS client file system, the `sshd` server, nor the pCacheFS file system have been optimized for the workload of a large build using a source tree mounted over SSHFS. There are performance bottlenecks in various areas and there are missing features in all layers.

Here are some ideas on how the current situation could be improved:

* Implement extended attributes in SSHFS and the SFTP server. This is potentially difficult because it requires changes to the OpenSSH server and [a previous attempt in 2011](https://bugzilla.mindrot.org/show_bug.cgi?id=1953) resulted in a patch that was not accepted mainline. At the very least, it would be nice to revive this patch on recent OpenSSH sources; a simple attempt I made at rebasing it resulted in conflicts that didn't seem trivial to resolve.

* Add a *remote-file-system-is-immutable* setting to SSHFS to enable "perfect caching". Turning this option on would cache the contents of files so that all file system operations on a file were local after fetching it. As a side-effect, the immense number of `getattr` operations issued to the server should become minimal and this should shift the bottleneck elsewhere. With caching of contents, the SSHFS could then expose the MD5 digests as extended attributes in constant time without needing to communicate these to the SFTP server.

* Reimplement pCacheFS as a C FUSE file system with proper threading. The pCacheFS layer as a standalone concept seems to be a nicer design than the previous item. Unfortunately, the current pCacheFS implementation does not yield the necessary performance, but reimplementing it in C and making proper use of threads would. As a side-effect, one could cache file contents using their MD5 as the key so that accessing files across different repository revisions would not necessarily cause a cache miss. Similarly, pCacheFS could on its own expose the MD5 of the files via extended attributes.

I consider my experimentation on this area done for now, but all of the items above sound interesting. In fact, after spending so many hours studying this, I cannot help but think of implementing a solution and watching it work. Maybe I'll give them a try... if I have the time.

Oh, and how easy this all was! Developing file system code using something like FUSE *cough*[rump](http://rumpkernel.org/)*cough* is a joy. The last time I dealt with low level file system code was [back in 2005 when I wrote tmpfs for NetBSD](http://netbsd-soc.sourceforge.net/projects/tmpfs/), and I did not have virtual machines nor user-space file systems available! *That* was painful.

# Annex: Contributions

This work resulted in the following open source contributions *so far*:

* [Pull request libfuse/sshfs#5](https://github.com/libfuse/sshfs/pull/5): **Merged the [osxfuse/sshfs](https://github.com/osxfuse/sshfs/) fork into libfuse's copy.** The differences between the two were minimal so it's good to have the master copy be portable by itself. Along the way, I also improved some of the OS X-specific code.

* [Pull request libfuse/sshfs#6](https://github.com/libfuse/sshfs/pull/6): **Implemented command-line options to tune the behavior of the SSHFS cache.** The code had various built-in constants to limit the cache size and configure its cleanup policies. As part of my testing, I had to make these values larger to prevent evictions from the cache, and making these customizable by the user would be good.

* [Pull request ibizaman/pcachefs#3](https://github.com/ibizaman/pcachefs/pull/3): **Fixed obvious breakage of pCacheFS** after implementing an entry point.

* [filesystems/fuse-cachefs package](http://pkgsrc.se/filesystems/fuse-pcachefs): **Added a pCacheFS package to pkgsrc**, for my own benefit in setting things up in OS X.
