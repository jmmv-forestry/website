---
title:      Compilers in the (BSD) base system
date:       2015-10-23 12:00:00 -0400
categories:
  - "bsd"
  - "compilers"
  - "essay"
  - "featured"
  - "software"
medium:     compilers-in-the-bsd-base-system-1c4515a18c49
aliases:
  - /blog/2015/10/23/compilers-in-the-bsd-base-system.html
---

A commonly held axiom in the BSD community is that the C compiler belongs in the base system. "This is how things have been since the beginning of time and they define the way BSD systems are", the proposition goes.

But why is that? What makes "having a compiler in base" a BSD system? Why is the compiler a necessary part of the base system? Hold on, is it? Could we take it out?

In this post, which is an extension to a reply I wrote in the ["Retiring in- tree GDB" mailing list thread on freebsd- arch](https://lists.freebsd.org/pipermail/freebsd-arch/2015-October/017394.html), I would like to examine possible answers to those questions.

# Why is the compiler in the base system?

Traditionally, BSD systems always required a compiler to be present because building from source was the only way to **keep the OS up-to-date**, to **tune the features of the kernel**, and to **install third-party software** from ports or pkgsrc.

There didn't exist any decent binary-only upgrade mechanisms for the base OS, the kernel was not modular nor did not have sufficient `sysctl(8)` tweaks, and the tools and repositories to install binary packages were very rudimentary and inflexible.

# The case for FreeBSD

Things have significantly changed over the last few years, especially for [FreeBSD Tier 1 platforms](https://www.freebsd.org/doc/en/articles/committers-guide/archs.html): it's now possible to run a fully-functional, up-to-date system, appropriately tuned for the machine at hand, with all kinds of third- party packages installed, without ever needing to compile anything.

> Having a compiler available at all times is not a necessity any longer. One
can get by with binaries just fine, which is a more convenient scenario.

These days, FreeBSD would not _need_ to ship a compiler by default any longer.  (Whether that _should_ be done is a different story though.)

In fact, as a long-time NetBSD user, I was a bit surprised when I came to FreeBSD because I found that the compiler tools were not optional. In NetBSD, the compiler tools have always been part of a comp.tgz set separate from base.tgz. Both are built from the source tree in unison, but when installing a new machine, you can easily choose not to have comp.tgz unpacked. I have run lean servers without compiler tools for a long time (by [building my packages elsewhere using pkg_comp](https://wiki.netbsd.org/tutorials/pkgsrc/pkg_comp_pkg_chk/)), and it was just fine.

# Let's keep the compiler in base

Regardless of the above, I do agree that the compiler should stay in the base system for a variety of reasons.

Without going into much detail, those reasons include: having a system that can build itself out-of-the-box in a consistent manner, having a system that can be trivially cross-compiled, and having a trustworthy compiler maintained by the same people that maintain the rest of the operating system.

Given the above, as a developer of the system, I do not want to have to care about the tricky integration points of a compiler with the complex source tree of an OS. These are details best left to a small team of compiler experts, who can and will do the right thing for the OS as a whole. You only need to witness NetBSD's super-simple cross-compilation features offered by build.sh to truly appreciate what I mean.

On that topic, I suggest watching the following presentation, which argues for a monolithic source tree in which the toolchain is managed by a small team of passionate experts:

<div class="frame">
  <div class="content">
    <iframe width="640" height="360" src="https://www.youtube.com/embed/zW-i9eVGU_k" frameborder="0" allowfullscreen></iframe>
  </div>
  <div class="footer">
    <p>Lessons in Sustainability, by Titus Winters. A key point of this talk is the justification for having a single "compiler team" within your infrastructure so that all the experts on the topic can work together and handle the tricky bits for you.</p>
  </div>
</div>

What should probably be done is make the installation of the compiler tools optional: when installing FreeBSD from a binary distribution, the user should have the choice to not install any of the compiler tools. I wonder what the implications of that would be though, because FreeBSD has shipped with built- in compiler tools for years and there might be subtle hidden dependencies on them.

# Building from source considered harmful

To conclude, I'll go on a bit of a tangent: making it a _standard practice_ for the user to compile anything at all is, for the majority of the cases, a horrible experience.

That said, there are a bunch of legitimate cases for building from source.  Namely:

* to apply code changes (duh),
* to tune compiler optimization settings,
* to disable features for smaller binaries,
* to disable features that have a measurable impact on performance---for whose run-time kill-switch is not sufficient to kill those implications, and
* to target a new platform.

If the cases above do _not_ apply, then compiling from source should not be _necessary_: alternatives exist, and they can be implemented. If building from source is necessary, either **you have done a poor job as a developer**---e.g. by not allowing sufficient run-time configuration---or **you do not have sufficient resources to run the project**---e.g. by being unable to provide binary packages for common platforms.

A pet peeve of mine are software packages whose functionality depends on the libraries chosen at build-time by means of configure switches. These kind of software packages are really problematic when the time to offer binary packages comes: "what options should you enable?" or "how will the user be able to choose a leaner installation?". There are mechanisms to allow the modification of dependencies at run time (think of dynamically-loadable plugins), but they often are _much_ more complex to implement than just configure switches.

The next time you tell a user of your software to "go and build from source", think if you could do something else to avoid that same situation in the future.
