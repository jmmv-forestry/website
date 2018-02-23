---
title:       Introducing sandboxfs
date:        2017-08-25 16:25:18 -0400
categories:
  - "bazel"
  - "software"
slug: introducing-sandboxfs
---

sandboxfs is a FUSE-based file system that exposes an arbitrary view of the
host's file system under the mount point, and offers access controls that
differ from those of the host. You can think of sandboxfs as an advanced
version of [bindfs](https://bindfs.org/) (or `mount --bind` or `mount_null(8)`
depending on your system) in which you can combine and nest directories under
an arbitrary layout.

The primary use case for this project is to provide a better file system
sandboxing technique for the Bazel build system. The goal here is to run each
build action (think compiler invocation) in a sandbox so that its inputs and
outputs are tightly controlled, and sandboxfs attempts to do this in a more
efficient manner than the current symlinks-based implementation.

But what makes sandboxfs more exciting are its potential secondary use cases
outside of Bazel. For example, my personal goal is to use sandboxfs within
[pkg_comp 2.x]({{< relref "2017-02-17-introducing-pkg_comp-2.0.md" >}}) to simplify
the logic in isolating pkgsrc builds and make the isolation more robust and
accurate.

So how did this happen? This summer I had the pleasure of hosting [Pallav
Agarwal](https://github.com/pallavagarwal07) as an intern in the
[Bazel](https://bazel.build/) team working from our Google NYC office. I
leveraged my [experience last year with sourcachefs]({{< relref
"2017-07-30-introducing-sourcachefs.md" >}}) to design and lead the
implementation of sandboxfs. With this and Pallav's strong skills, we got to a
feature-complete implementation by the beginning of August.

And today, after a bit of extra work to make the full codebase open-sourceable
and collecting all necessary approvals, I am happy to announce that sandboxfs
is public!

Read [the official
announcement](https://blog.bazel.build/2017/08/25/introducing-sandboxfs.html)
for more details and head to the [project
page](https://github.com/bazelbuild/sandboxfs/) to check out the code.

Enjoy and stay tuned for further integrations! sandboxfs is a cool thing on its
own, but until it serves as the base for builds within Bazel and pkg_comp, it's
not of much use. Or is it? If you have other use cases, let me know!
