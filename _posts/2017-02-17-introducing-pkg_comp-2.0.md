---
layout:      post
title:       Introducing pkg_comp 2.0 (and sandboxctl 1.0)
date:        2017-02-17 16:37:06 -0500
categories:  software
excerpt:
    Announcing the launch of pkg_comp 2.0, how this differs from the 1.x series,
    why there was a rewrite, what sandboxctl 1.0 is, and more.
---

After many (many) years in the making, **[pkg_comp](https://github.com/jmmv/pkg_comp/) 2.0 and its companion [sandboxctl](https://github.com/jmmv/sandboxctl/) 1.0 are finally here!**

Read below for more details on this launch.  I will publish detailed step-by-step tutorials on setting up periodic package rebuilds in separate posts.

# What are these tools?

**pkg_comp is an automation tool to build [pkgsrc](http://pkgsrc.org/) binary packages inside a chroot-based sandbox.**  The main goal is to fully automate the process and to produce clean and reproducible packages.  A secondary goal is to support building binary packages for a different system than the one doing the builds: e.g. building packages for NetBSD/i386 6.0 from a NetBSD/amd64 7.0 host.

The **highlights of pkg_comp 2.0**, compared to the 1.x series, are: **multi-platform support**, including NetBSD, FreeBSD, Linux, and macOS; **use of [pbulk](https://www.netbsd.org/docs/pkgsrc/bulk.html)** for efficient builds; **management of the pkgsrc tree** itself via CVS or Git; and a more **robust and modern codebase**.

**sandboxctl is an automation tool to create and manage chroot-based sandboxes on a variety of operating systems**.  sandboxctl is the backing tool behind pk_comp.  sandboxctl hides the details of creating a functional chroot sandbox on all supported operating systems; in some cases, like building a NetBSD sandbox using release sets, things are easy; but in others, like on macOS, they are horrifyingly difficult and brittle.

# Storytelling time

pkg_comp's history is a long one.  pkg_comp 1.0 first appeared in pkgsrc on September 6th, 2002 as the `pkgtools/pkg_comp` package in pkgsrc.  As of this writing, the 1.x series are at version 1.38 and have received contributions from a bunch of pkgsrc developers and external users; even more, the tool was featured in the [BSD Hacks book](http://shop.oreilly.com/product/9780596006792.do) back in 2004.

This is a *long* time for a shell script to survive in its rudimentary original form: pkg_comp 1.x is now a teenager at its 14 years of age and is possibly one of my longest-living pieces of software still in use.

## Motivation for the 2.x rewrite

For many of these years, I have been wanting to rewrite pkg_comp to support other operating systems.  This all started when I first got a Mac in 2005, at which time pkgsrc already supported Darwin but there was no easy mechanism to manage package updates.  What would happen&mdash;and still happens to this day!&mdash;is that, once in a while, I'd realize that my packages were out of date (read: insecure) so I'd wipe the whole pkgsrc installation and start from scratch.  Very inconvenient; I had to automate that properly.

Thus the main motivation behind the rewrite was primarily to support macOS because this was, and still is, my primary development platform.  The secondary motivation came after writing sysbuild in 2012, which trivially configured daily builds of the NetBSD base system from cron; I wanted the exact same thing for my packages.

## One, two... no, three rewrites

The first rewrite attempt was sometime in 2006, soon after I learned Haskell in school.  Why Haskell?  Just because that was the new hotness in my mind and it seemed like a robust language to drive a pretty tricky automation process.  That rewrite did not go very far, and that's possibly for the better: relying on Haskell would have decreased the portability of the tool, made it hard to install it, and guaranteed to alienate contributors.

The second rewrite attempt started sometime in 2010, about a year after I joined Google as an SRE.  This was after I became quite familiar with Python at work, wanting to use the language to rewrite this tool.  That experiment didn't go very far though, but I can't remember why... probably because I was busy enough at work and creating Kyua.

The third and final rewrite attempt started in 2013 while I had a summer intern and I had a little existential crisis.  The year before I had written [sysbuild]({%post_url 2012-07-25-introducing-sysbuild-for-netbsd%}) and [shtk]({%post_url 2012-08-15-introducing-shtk%}), so I figured recreating pkg_comp using the foundations laid out by these tools would be easy.  And it was... to some extent.

Getting the barebones of a functional tool took only a few weeks, but that code was far from being stable, portable, and publishable.  Life and work happened, so this fell through the cracks... until late last year, when I decided it was time to close this chapter so I could move on to some other project ideas.  To create the focus and free time required to complete this project, I had to shift my schedule to start the day at 5am instead of 7am&mdash;and, many weeks later, the code is finally here and I'm still keeping up with this schedule.

Granted: this third rewrite is not a fancy one, but it wasn't meant to be.  pkg_comp 2.0 is still written in shell, just as 1.x was, but this is a good thing because bootstrapping on all supported platforms is easy.  I have to confess that I also considered Go recently [after playing with it last year]({%post_url 2016-03-22-golang-review%}) but I quickly let go of that thought: at some point I had to ship the 2.0 release, and 10 years since the inception of this rewrite was about time.

## The launch of 2.0

On February 12th, 2017, the authoritative sources of pkg_comp 1.x were moved from `pkgtools/pkg_comp` to `pkgtools/pkg_comp1` to make room for the import of 2.0.  Yes, the 1.x series only existed in pkgsrc and the 2.x series exist as a [standalone project on GitHub](https://github.com/jmmv/pkg_comp).

And here we are.  Today, February 17th, 2017, pkg_comp 2.0 saw the light!

# Why sandboxctl as a separate tool?

sandboxctl is the supporting tool behind pkg_comp, taking care of all the logic involved in creating chroot-based sandboxes on a variety of operating systems.  Some are easy, like building a NetBSD sandbox using release sets, and others are horrifyingly difficult like macOS.

In pkg_comp 1.x, this logic used to be bundled right into the pkg_comp code, which made it pretty much impossible to generalize for portability.  With pkg_comp 2.x, I decided to split this out into a separate tool to keep responsibilities isolated.  Yes, the integration between the two tools is a bit tricky, but allows for better testability and understandability.  Lastly, having sandboxctl as a standalone tool, instead of just a separate code module, gives you the option of using it for your own sandboxing needs.

I know, I know; the world has moved onto containerization and virtual machines, leaving chroot-based sandboxes as a very rudimentary thing... but that's all we've got in NetBSD, and pkg_comp targets primarily NetBSD.  Note, though, that because pkg_comp is separate from sandboxctl, there is nothing preventing adding different sandboxing backends to pkg_comp.

# Installation

Installation is still a bit convoluted unless you are on one of the tier 1 NetBSD platforms or you already have pkgsrc up and running.  For macOS in particular, I plan on creating and shipping a installer image that includes all of pkg_comp dependencies&mdash;but I did not want to block the first launch on this.

For now though, you need to download and install the latest source releases of [shtk](https://github.com/jmmv/shtk/), [sandboxctl](https://github.com/jmmv/sandboxctl/), and [pkg_comp](https://github.com/jmmv/pkg_comp/)&mdash;in this order; pass the `--with-atf=no` flag to the `configure` scripts to cut down the required dependencies.  On macOS, you will also need [OSXFUSE](https://osxfuse.github.io/) and the [bindfs](http://bindfs.org) file system.

If you are already using pkgsrc, you can install the `pkgtools/pkg_comp` package to get the basic tool and its dependencies in place, or you can install the wrapper `pkgtools/pkg_comp-cron` package to create a pre-configured environment with a daily cron job to run your builds.  See the package's `MESSAGE` (with `pkg_info -E pkg_comp-cron`) for more details.

# Documentation

Both pkg_comp and sandboxctl are fully documented in manual pages.  See `pkg_comp(8)`, `sandboxctl(8)`, `pkg_comp.conf(5)` and `sandbox.conf(5)` for plenty of additional details.

As mentioned at the beginning of the post, I plan on publishing one or more tutorials explaining how to bootstrap your pkgsrc installation using pkg_comp on, at least, NetBSD and macOS.  Stay tuned.

And, if you need support or find anything wrong, please let me know by filing bugs in the corresponding GitHub projects: [jmmv/pkg_comp](https://github.com/jmmv/pkg_comp/issues) and [jmmv/sandboxctl](https://github.com/jmmv/sandboxctl/issues).
