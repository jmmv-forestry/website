---
layout: post
title: "#! /usr/bin/env considered harmful"
date:  2016-09-14 07:07:46 -0400
categories: portability programming scripts unix
---

Many programming guides recommend to begin scripts with the `#! /usr/bin/env` [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) in order to to automatically locate the necessary interpreter. For example, for a Python script you would use `#! /usr/bin/env python`, and then the saying goes, the script would "just work" on any machine with Python installed.

The reason for this recommendation is that `/usr/bin/env python` will search the `PATH` for a program called `python` and execute the first one found... and that usually works fine *on one's own machine*.

Unfortunately, this advice is plagued with problems and assuming it will work is wishful thinking. Let me elaborate. I'll use Python below for illustration purposes but **the following applies equally to any other interpreted language.**

## Problems

*i)* The first problem is that **using `#! /usr/bin/env` lets you find *an* interpreter but not necessarily the *correct* interpreter**. In our example above, we told the system to look for an interpreter called `python`... but we did not say *anything* about the compatible versions. Did you want Python 2.x or 3.x? Or maybe "exactly 2.7"? Or "at least 3.2"? You can't tell right? So the the computer can't tell either; regardless, the script *will* probably run with whichever version happens to be called `python`--which could be *any* thanks to the [alternatives system](https://wiki.debian.org/DebianAlternatives). The danger is that, if the version is mismatched, the script will fail and the failure can manifest itself at a much later stage (e.g. a syntax error in an infrequent code path) under obscure circumstances.

*ii)* The second problem, assuming you ignore the version problem above because your script is compatible with all possible versions (hah), is that **you may pick up an interpreter that does not have all prerequisite dependencies installed**. Say your script decides to import a bunch of third-party modules: where are those modules located? Typically, the modules exist in a centralized repository that is specific to the interpreter installation (e.g. a `.../lib/python2.7/site-packages/` directory that lives alongside the interpreter binary). So maybe your program found a Python 2.7 under `/usr/local/bin/` but in reality you needed it to find the one in `/usr/bin/` because that's where all your Python modules are. If that happens, you'll receive an obscure error that doesn't properly describe the exact cause of the problem you got.

*iii)* The third problem, assuming your script is portable to all versions (hah again) and that you don't need any modules (really?), is that **you are assuming that the interpreter is available via a specific name**. Unfortunately, the name of the interpreter can vary. For example: pkgsrc installs all `python` binaries with explicitly-versioned names (e.g. `python2.7` and `python3.0`) to avoid ambiguity, and no `python` symlink is created by default... which means your script won't run at all even when Python is seemingly installed.

*iv)* The fourth problem is that **you cannot pass flags to the interpreter**. The shebang line is intended to contain the name of the interpreter plus a single argument to it. Using `/usr/bin/env` as the interpreter name consumes the first slot and the name of the interpreter consumes the second, so there is no room to pass additional flags to the program. What happens with the rest of the arguments is platform-dependent: they may be all passed as a single string to `env` or they may be tokenized as individual arguments. This is not a huge deal though: one argument for flags is too restricted anyway and you can usually set up the interpreter later from within the script.

*v)* The fifth and worst problem is that **your script is at the mercy of the user's *environment* configuration**. If the user has a "misconfigured" `PATH`, your script will mysteriously fail at run time in ways that you cannot expect and in ways that may be very difficult to troubleshoot later on. I quote "misconfigured" because the problem here is very subtle. For example: I do have a shell configuration that I carry across many different machines and various operating systems; such configuration has complex logic to determine a sane `PATH` regardless of the system I'm in... but this, in turn, means that the `PATH` can end up containing more than one version of the same program. This is fine for interactive shell use, but it's not OK for any program to assume that my `PATH` will match their expectations.

*vi)* The sixth and last problem is that **a script prefixed with `#! /usr/bin/env` is not suitable to being installed**. This is justified by all the other points illustrated above: once a program is installed on the system, it must behave deterministically no matter how it is invoked. More importantly, when you install a program, you do so under a set of assumptions gathered by a `configure`-like script or prespecified by a package manager. To ensure things work, the installed script must see the exact same environment that was specified at installation time. In particular, the script must point at the correct interpreter version and at the interpreter that has access to all package dependencies.

## When is it OK?

All this considered, you may still use `#! /usr/bin/env` for the **convenience of your own throwaway scripts** (those that don't leave your machine).

You may also use this shebang **for documentation purposes and as a placeholder for a better default**: for example, you could patch up the scripts during `make install` to point to the right interpreter, which is pretty much what pkgsrc (and likely any other packaging system) does automatically. **Just don't assume that the magic `#! /usr/bin/env foo` is sufficient or even correct** for the final installed program.

*Bonus chatter:* Did you know that the [traditional shebang prefix is `#! `](https://en.wikipedia.org/wiki/Shebang_(Unix)#History) (note the trailing space)? This 3-byte character sequence was the one that the original Unix kernel searched for to determine if an external interpreter was necessary, not just `#!`.
