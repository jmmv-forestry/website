---
title:       Introducing sourcachefs
date:        2017-07-30 20:30:00 -0400
categories:
  - "software"
excerpt:
    Announcing the launch of sourcachefs, a FUSE-based persistent caching layer.
slug: introducing-sourcachefs
---

You may remember a post from over a year ago titled [Analysis of SSHFS performance for large builds]({{< relref "2016-02-17-sshfs-performance-analysis-for-builds.md" >}}), in which I outlined how Google exposes its gigantic source monorepo via a FUSE file system and in which I analyzed the performance of large builds using SSHFS to access such file system.

As part of those experiments, I played with [pCacheFS](https://github.com/ibizaman/pcachefs), a Python-based FUSE file system that provides a persistent caching layer on to top of a slow mount point.  Pure SSHFS benchmarks were poor performance-wise, and pCacheFS benchmarks were not better.  In the former case, the issues were because of the lack of caching and single-threaded server operation, and in the latter because of slow performance of a CPU-bound multi-threaded Python app.

As a result, I wrote a new file system to act as a persistent caching layer on top of an SSHFS mount, and I called that file system **sourcachefs** (note the missing *e* for a cool pun).  sourcachefs implements the basic same idea behind pCacheFS but in Go for efficiency, with more features, and with a lot of performance tuning into it.

Further experiments with sourcachefs *did* show up performance improvements in the builds involved, but sourcachefs was never deployed widely within Google for complex reasons I won't get into (plus we got a much better solution to the problem we were originally facing).  At this point, sourcachefs is just a personal project of mine that has no involvement with my daily job, but very soon you'll see the publication of a different project that shares a lot in common with sourcachefs!

I digress.  Today, after over a year of finding little chunks of time during long flights to clean up the code base, it has become minimally worthy of publication... so I have pushed the code to GitHub.  Would be a pity for it to be lost, even if it's just my first Go incomplete experiment.

Head to <http://github.com/jmmv/sourcachefs/> for details.

&mdash; Julio, from [DL439](https://flightaware.com/live/flight/DAL439/history/20170730/1925Z/KJFK/KSFO) at 36000 feet.
