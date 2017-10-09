---
layout:      post
title:       Fighting execs via sandboxfs on macOS
date:        2017-10-06 16:27:34 -0400
categories:  software
excerpt:
  Since the announcement of sandboxfs a few weeks ago, I've been stabilizing its integration with Bazel as a new sandboxing technique.  As part of this work, I encountered issues when macOS was immediately killing signed binaries executed through the sandbox.  Read on for the long troubleshooting process and the surprising trivial solution.
---

A few weeks ago, [we announced sandboxfs]({% post_url 2017-08-25-introducing-sandboxfs %}): a FUSE file system to expose an arbitrary view of the host's file system.  We intend to use this file system in [Bazel](http://bazel.build/) to provide a faster and more correct sandboxing technique for build actions.

Since then, I've been actively working on stabilizing sandboxfs per se and its integration with Bazel.  The first milestone, which we haven't reached yet, is to get Bazel to self-build on macOS with sandboxfs.  The second milestone, which obviously depends on builds being stable, is performance evaluation and optimization.  The goal is to measure the behavior of this technique against previous sandboxing strategies on the Mac.  Depending on the numbers, we'll decide whether it makes sense to continue investing in the sandboxfs idea or not.

Work on the first milestone has been far from easy.  Getting sandboxfs to a sufficiently stable state that is able to support Bazel's self-build has been very tricky.  The original implementation was written on Linux and, even though FUSE should be the same across systems, there are subtle (unexpected) differences that cause strange behaviors.

The last issue in this saga was "fun" to troubleshoot and fix.  As I was telling the story to a coworker, I realized how ridiculous this all was... so I decided to write it down for you.  As you will see, the fix was pretty much a one-liner&mdash;but understanding what was happening took hours and writing tests for the fix took days.

# Problem statement

Bazel uses sandboxfs to expose a directory tree that contains the tools required for a build action, the sources for the action, and a writable directory for the outputs.  For a Java action, the tree needs to contain the JDK mapped into the view.

These actions were failing and in not very obvious ways.  (Bazel hides the failure message from the subprocess and I haven't spent much time in figuring out why.)  To reproduce, I set up my own minimal sandboxfs instance mimicking what Bazel was requesting for the action and ran Java from it:

```
$ mkdir /tmp/bin
$ cp /usr/bin/java /tmp/bin
$ sandboxfs static --read_only_mapping=/:/tmp/bin /tmp/mnt &
$ /tmp/mnt/java
Killed: 9
```

Oh wow.  Such error.  Much descriptive.

# Let's troubleshoot

**Q. Bazel only maps individual files in the sandbox (e.g. the Java binary).  Did Bazel forget to map additional files required to start up the Java process?**

A. It was possible that Java (or dyld or whatever else the process needs to start up) needed to access many more files than the ones that were mapped by Bazel for some reason, so I set up a looser sandboxfs instance to expose my full file system:

```
$ sandboxfs static --read_only_mapping=/:/ /tmp/mnt &
$ /tmp/mnt/usr/bin/java
Killed: 9
```

And no, that was not the problem.  Not surprising given that the other sandboxing technique implemented in Bazel is known to work just fine.

**Q. What system calls is the process issuing that need to be served by FUSE?  Maybe the execution was trying to access a file in a way that was not properly implemented within sandboxfs.**

A. To look into this, I would have used `ktrace`... but to my surprise, this old trusty tool is gone from macOS Sierra and replaced with something completely different in macOS High Sierra.

There are alternatives though.

`fs_usage`, which is not as simple nor as comprehensive as `ktrace`, could do the job.  But no, nothing. `fs_usage` caught zero accesses from the attempt to run Java from the sandbox.  Maybe the fancier *Instruments* could help, which I have little experience with... but no, nothing either.

What?  How is that possible?  Am I misusing the tools?  I'd expect at least some system call by dyld trying to load shared libraries...  Given confusion, I resorted to reading more documentation and playing around with known-good cases.  But no luck.

**Q. Maybe the process is truly killed before it has even had a chance to do anything.  What does the kernel think?**

A. Let's see:

```
$ sudo dmesg
[...]
AMFI: code signature validation failed.
/private/tmp/mnt/java: Possible race detected. Rejecting.
mac_vnode_check_signature: /private/tmp/mnt/java: code signature validation failed fatally: When validating /private/tmp/mnt/java:
  The code contains a Team ID, but validating its signature failed.
Please check your system log.proc 49122: load code signature error 4 for file "java"
```

There you go.  Something about signatures and a "possible race condition".  Yikes: troubleshooting either can be painful.  Which is it gonna be?

**Q. Let's start with the signatures, as that's potentially easier to figure out than catching a race.  Where are the signatures stored?**

A. My first thought was "extended attributes" given how macOS has traditionally enjoyed storing file information in resource forks.  sandboxfs does not yet implement extended attributes so, if macOS stored anything regarding signatures in them, validation wouldn't work:

```
$ ls -Ll /usr/bin/java
-rwxr-xr-x  1 root  wheel  58336 Sep 21 00:34 /usr/bin/java
```

No, no extended attributes for the binary under test (note there is no `@` sign after the permissions). Nothing.

That said, as the failure was so mysterious, I instrumented sandboxfs to print requests for extended attributes in case those were being requested for some other file, and there indeed was one read for `com.apple.quarantine` on the binary.  Could be related given the name, but doubtful because the attribute was not on the binary.

**Q. What about the read path?  If reads misbehave, that could cause signature validation to fail.**

A. I reviewed the code in detail without finding anything obviously wrong, but that's not sufficient to prove there is no problem.  File systems are complex beasts and it's hard to know if you are handling an operation correctly unless you know of all possible corner cases (and I don't know them all).

Fortunately, there are many more FUSE file systems out there with which to play. I built [bindfs](http://bindfs.org/) and tried mapping the exact same files as with sandboxfs... and voila, things worked just fine: Java started up as expected.

OK, good.  That means that FUSE works fine even after the update to High Sierra and that I have a baseline with which to compare behavior.  I modified the bindfs code to print a trace of all file opens and reads, did the same in sandboxfs, and compared the two traces.  Identical (same operations, same arguments, etc.), up to the crash point.

**Q. Maybe the operations we implement are correct, but are we implementing all operations that are necessary?**

A. At first, I just tried to map a different binary into the sandboxfs, like `/bin/ls` and run that.  This worked fine, so it seems executions do work through the file system (which in turn means paging ought to be working correctly).

But let's look in more detail.  bindfs implements FUSE hooks that sandboxfs does not yet (like the extended attributes ones that we already discarded), so maybe those silent rejections from sandboxfs are what cause the problem.  A cursory review of all possibilities didn't show anything obvious other than `statvfs` not being there.

Running sandboxfs with `--debug` showed that `statvfs` was being called multiple times, so maybe the verification process wanted to know something about the file system size?  I tried adding a fake implementation of statvfs to sandboxfs but no luck either.

**Q. Then we have to go back to the difficult case.  Is it a race condition?**

A. Assuming there is a race condition, *where* is it?  Sure, sandboxfs is heavily threaded, but is the race there?  How could the kernel even know if that was the case?  (It can't&mdash;much less with goroutines as they don't have a 1:1 mapping with a kernel primitive.)

*[Shudder]* Are the Go FUSE bindings handling kernel requests as a whole incorrectly and the incorrect order trips the kernel's race condition detection?  Note that bindfs is written in C so it uses a completely different FUSE stack, so there could indeed be something fishy in the Go one.

Nah, crazy talk.  No desire to go down this route just yet, so let's think about other possibilities.

**Q. We have been assuming that those entries in dmesg come from the kernel, but do they?**

A. Google turned out nothing useful: searching for parts of the error messages found some forum posts with users reporting similar issues... but as you may expect for obscure problems, all answers were non-sensical or [missing](https://xkcd.com/979/).

Google also turned out some results for the open-source Darwin sources when I searched for the `mac_vnode_check_signature` message, but searching the other parts of the message in the returned file wasn't successful.

Given the difficulty in running textual queries on the web UI for the sources, I downloaded the Darwin sources and ran `grep -ri` on them for various parts of the error message.  Nothing.  What? It's indeed not the kernel coming up with the denial for the verification: the message must be coming from a kernel extension... or a userspace component?

Let's take out the big guns:

```
$ find /System -type f -print0 | xargs -0 -P 12 -n 1 sh -c 'if strings "$0" | grep "Possible race detected"; then echo "$0"; fi'
%s: Possible race detected. Rejecting.
/System/Library/Extensions/AppleMobileFileIntegrity.kext/Contents/MacOS/AppleMobileFileIntegrity
```

(Did I just grep my whole system for an error string?  Yes I did.  Not the first time I use this technique to find culprits, and not the last one either I suspect.  It's pretty effective.)

Look, one match!

**Q. AppleMobileFileIntegrity.  That sounds suspicious.  What is that thing?**

A. Google turned out several results, most pointing at forum threads about rooting iPhones or bypassing security protections&mdash;something I was not interested in.

This led me to discover the `amfid` daemon, which as you may expect is not documented (its manual page is a joke), and invoking it for help didn't produce anything useful.

**Q. *[Mind wanders]* Let me interrupt you for a second.  I just had an idea!  Are the FUSE-level mount options different between sandboxfs and bindfs?**

A. The `fusermount` binary, which is a helper tool that actually configures the file system's mount point, accepts a bunch of options to configure how the mount point is set up.  These could be different between sandboxfs and bindfs causing the behavior discrepancy.

Some code inspection yielded that the answer is yes: the options differ.  One of them caught my eye: `-o allow_other`.  So I patched this into sandboxfs, which was a matter of adding a the single extra parameter `fuse.AllowRoot()` to the mount call... and...

Ta-da!  Java now started.

**Q. Waaaaaaat? 3 hours into this for this stupid problem?!?!**

A. Yep.  Stupid problem, but finding the solution is always regarding.  So far, we have gained a lot of context on what's going on and we know what needs to change for the problem to go away.

And then it dawned on me.  The `amfid` daemon!  What is it running as?!

```
$ ps aux | grep amfi[d]
root             75739   0.0  0.1  2495744  12824   ??  Ss    2:22PM   0:00.04 /usr/libexec/amfid
```

That explains it.

Let's rationalize the problem:

1.   You try to exec Java from within the sandboxfs.
1.   The kernel gets the execution request and maps the executable into memory.
1.   The kernel issues a few reads on the file and determines somehow that it needs to validate the signature.
1.   The kernel calls out to the `amfid` daemon, running in as root.
1.   The `amfid` daemon tries to read the executable and fails because the file system in which it lives was not mounted to allow root to read from it.
1.   The `amfid` daemon tells the kernel that there was a race condition: the executable that the kernel told it to inspect is now gone.
1.   The kernel cannot verify the signature so it terminates the process.

Simple, huh?  Well, that's my current working theory.  Since I fixed the problem, I haven't been able to reproduce it any longer.  Is the kernel caching signature verifications anywhere?  Maybe, but I couldn't figure that out.  Did the recent update of OSXFUSE fix something within it?  Did the Xcode update do so?  Too many moving pieces.

# The fix

The one-line fix mentioned above became a multi-line fix because of the desire to expose the permissions tunable to the user.

I ended up adding a new `--allow` flag to sandboxfs that can take one of: `self` to indicate default access; `other` to indicate that any user can access the file system; and `root` to indicate that only the user that mounted the file system and root can access it.  But still: this was doable in like 20, 30 minutes tops.

Now, testing the new feature was harder and it took several hours over several days to get the tests right.  This is a horror story for another day.
