---
title: "On Bazel and Open Source"
date: 2015-04-14 16:00:00 -0400
categories:
  - "featured"
  - "google"
  - "software"
julipedia: 2015/04/on-bazel-and-open-source.html
slug: on-bazel-and-open-source
---
This is a rare post because I don't usually talk about Google stuff
here, and this post is about Bazel: a tool recently published by Google.
Why? Because I love its internal counterpart, Blaze, and believe that
Bazel has the potential to be one of the best build tools if it is not
already.

However, Bazel currently has some shortcomings to cater to a certain
kind of important projects in the open source ecosystem: the projects
that form the foundation of open source operating systems. This post is,
exclusively, about this kind of project.

For this essay more than ever: **the opinions in this post are purely my
own and I have no affiliation to the Blaze team**. But yes, I have used
Blaze for years.

And for those that don't know me, why am I writing this? Because, first
and foremost, I am a "build system junkie" and thus I have general
interest in this topic. And second, because I have written various open
source software components and packaged countless projects for various
operating systems, including NetBSD, FreeBSD, and Fedora; all this for
longer than I've been at Google. In fact, I was NetBSD's sole Gnome 2.x
maintainer for about 3 years&mdash;yeah, call me masochist. These activities
led me to learn a lot about: build systems; the way a great bunch of
upstream maintainers think and behave; and a ton on how to write
portable software that can be built and installed with minimum fuss. I'm
far from an expert on the topic though.

Let's get started.

------------------------------------------------------------------------

About three weeks ago, Google released [Bazel](http://bazel.io/): the
open source variant of Google's internal build system known as Blaze.
During the six years I have been at Google, I have heard various
individuals wishing for an open source version of Blaze and, finally, it
has happened! This is a big milestone and, all things considered, a
great contribution to the open source community. Kudos to the team that
pulled this off.

What I would like to do with this post is, for the most part, guide you
through how *a sector of the open source world* currently builds
software and, to a lesser extent, present why Bazel is not yet a
suitable build system **for this specific use case**. By "open source
world" I am specifically referring to **the ecosystem of low-level
applications that form a Unix-like operating system** these days, the
majority of which are written in C, C++, and interpreted languages such
as Python. There certainly are plenty of *other* use cases for which
Bazel makes a lot of sense (think higher-level apps, Android, etc.), but
I won't be talking about these here because I do not know their needs.

# What is Bazel?

<img src="/images/2015-04-14-BazelLogo.png" width="300"
     class="float-right" />

Bazel, just as Blaze, is an exemplary build system. As its tagline
*{Fast, Correct} - Choose two* claims, Bazel is a fast build system and
a correct build system. Correct in this context means that Bazel
accurately tracks dependencies across targets, and that it triggers
rebuilds whenever the slightest changes. Fast in this context refers to
the fact that Bazel is massively parallel and that, thanks to accurate
dependency tracking, Bazel only rebuilds the targets that really need to
be rebuilt.

But the above two qualities are just a byproduct of something more
fundamental, which in my opinion is the killer feature in Bazel.

Bazel build rules are defined in `BUILD` files, and **the build rules
are specified at a very high semantical level**. Compared to `make(1)`,
where you specify dependencies among files or phony targets, Bazel
tracks dependencies across "concepts". You define libraries; you define
binaries; you define scripts; you define data sets. Whatever it is that
you define, the target has a special meaning to Bazel, which in turn
allows Bazel to perform more interesting analyses on the targets. Also,
thanks to this high level of abstraction, **it is very hard to write
incorrect build rules** (thus helping enforce the correctness property
mentioned above).

Consider the following made-up example:

    cc_binary(
        name = "my_program",
        srcs = ["main.cpp"],
        deps = [":my_program_lib"],
    )

    cc_library(
        name = "my_program_lib",
        srcs = [
            "module1.cpp",
            "module2.cpp",
        ],
    )

    cc_test(
        name = "module1_test",
        srcs = "module1_test.cpp",
        deps = [
            ":my_program_lib",
            "//something/unclear/googletest",
        ],
    )

This simple `BUILD` file should be readable to anyone. There is a
definition of a binary program, its backing library, and a test program.
All the targets have an explicit "type" and the properties they accept
are type-specific. Bazel can later use this information to decide how to
best build and link each target agains the others (thus, for example,
hiding all the logic required to build static or shared libraries in a
variety of host systems).

Yes. It's that simple. Don't let its simplicity eclipse the power
underneath.

# The de-facto standard: the autotools

The open source world is a mess of build tools, none of which is praised
by the majority; this is in contrast to Blaze, about which I have not
heard any Googler complain&mdash;and some of us are true nitpickers. There are
generic build systems like the
[autotools](http://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html),
[cmake](http://www.cmake.org/), [premake](http://premake.github.io/),
[SCons](http://www.scons.org/), and
[Boost.Build](http://www.boost.org/build/); and there are
language-specific build systems like
[PIP](https://pypi.python.org/pypi/pip/) for Python,
[PPM](https://metacpan.org/pod/PPM) for Perl, and
[Cabal](https://www.haskell.org/cabal/) for Haskell. (As an interesting
side note, Boost.Build is probably the system that resembles Bazel the
most conceptually... but Boost.Build is actively disliked by anyone who
has ever tried to package Boost and/or fix any of its build rules.)

Of all these systems, the one that eclipses the others for historical
reasons (at least for the use case we are considering) is the first one:
the *autotools*, which is the common term used to refer to the Automake,
Autoconf, Libtool, and pkg-config combo. This system is ugly because of
its arcane syntax&mdash;m4, anyone?&mdash;and, especially, because it does a very
poor job at providing a highly semantical build system: the details of
the underlying operating system leak through the autotools' abstractions
constantly. This means that few people understand how the autotools work
and end up copy/pasting snippets from anywhere around the web, the
majority of which are just wrong.

However, despite the autotools' downsides, the workflow they
provide&mdash;`configure`, `build`, `test`, and `install` for everyone, plus
an optional `dist` step for the software publisher&mdash;is extremely
well-known. What's more important is that any binary packaging system
out there&mdash;say RPM, debhelper, or [pkgsrc](http://www.pkgsrc.org/)&mdash;can
cope with autotools-based software packages with zero effort. In fact,
*anything that does not adhere to the autotools workflow is a nightmare
to repackage*.

The autotools have *years* of mileage via thousands of open source
projects and are truly mature. If used properly&mdash;which in itself is
tricky, although possible thanks to their excellent documentation&mdash;the
results are software packages that are trivial to build and that
integrate well with almost any system.

What I want to say with all this is that the autotools are *the*
definition&mdash;for better or worse&mdash;of how build systems need to behave in
the open source world. So, when a new exciting build tool appears, it
must be analyzed through the "autotools distortion lenses". Which is
what I'm doing here for Bazel.

# Issue no. I: Cross-project dependency tracking

Blaze was designed to work for Google's unified codebase and Bazel is no
different. The implication of a unified source tree is that all
dependencies for a given software component exist *within* the tree.
This is just not true in the open source world where the vast majority
of software packages have dependencies on other libraries or tools,
which is a good thing. But I don't see how Bazel copes with this yet.

Actually, the problem is not only about specifying dependencies and
checking for their existence: it is about being able to programmatically
know how to *use* such dependencies. Say your software package needs
`libfoo` to be present: that's easy enough to check for, but it is not
so easy to know that you need to pass `-I/my/magic/place/libfoo-1.0` to
the compiler and
`-pthread -L/some/other/place/ -Wl,-R/yet/more/stuff -lfoo` to the
linker to make use of the library. The necessary flags vary from
installation to installation if only because the Linux ecosystem is a
mess on its own.

The standard practice in the open source world is to use
[pkg-config](http://www.freedesktop.org/wiki/Software/pkg-config/) for
build-time dependency discovery and compiler configuration. Each
software package is expected to install a `.pc` file that, in the usual
case, records the compiler and linker flags required to use the
corresponding library. At build time, the depending package searches for
the needed library through the installed `.pc` files, extract the flags,
and uses them. This has its own problems but works well enough in
practice.

I am sure it is possible to shell out to pkg-config in Bazel to
integrate with other projects. After all, the `genrule` feature provides
raw access to Python to define custom build rules. But, by doing that,
it is very easy to lose Bazel's promises of *correct* builds because
writing such low-level build rules in a bulletproof manner is difficult.

Ergo, to recap this section: the first shortcoming is that Bazel does
not provide a way to discover external dependencies in the installed
system and to use them in the correct manner. Providing *an "official"
and well-tested* set of build rules for pkg-config files could be a
possible solution to this problem.

# Issue no. II: Software autoconfiguration

Another very common need of open source projects is to support various
operating systems and/or architectures. Strictly speaking, this is not a
"need" but a "sure, why not" scenario. Let me elaborate on that a bit
more.

Nowadays, the vast majority of open source developers target Linux as
their primary platform and they do so on an x86-64 machine. However,
*that does not mean* that those developers intentionally want to ban
support for other systems; in fact, these developers will happily accept
portability fixes to make their software run on whatever their users
decide to port the software to. You could argue that this is a moot
point because the open source world is mostly Linux on Intel... but no
so fast. The portability problems that arise between different operating
systems *also* arise between *different Linux distributions*. Such is
the "nice" (not) world of Linux.

The na&iuml;ve solution to this problem is to use preprocessor conditionals
to detect the operating system or hardware platform in use and then
decide what to do in each case. This is **harmful** because the code
quickly becomes unreadable and because this approach is not
"future-proof". (I wrote a couple of articles years ago, Making
Packager-Friendly Software: [part
1](http://www.onlamp.com/pub/a/onlamp/2005/03/31/packaging.html), [part
2](http://www.onlamp.com/pub/a/onlamp/2005/04/28/packaging2.html), on
this topic.) It seems to me that, today, this might be the only possible
solution for projects using Bazel... and this solution is not a good
one.

The open source world deals with system differences via run-time
configuration scripts, or simply "configure scripts". configure scripts
are run *before* the build and they check the characteristics of the
underlying system to adjust the source code to the system in use&mdash;e.g.
does your `getcwd` system call accept `NULL` as an argument for dynamic
memory allocation? configure-based checks *can* be much more robust than
preprocessor checks (if written properly).

I suspect that one could use a traditional "configure" script with
Bazel. After all, the main goal of configure is to create a `config.h`
file with the settings of the underlying system and this can be done
regardless of the build system in use. Unfortunately, this is a very
simplistic view of the whole picture. Integrating autoconf in a project
is much more convoluted and requires tight integration with the build
system to get a software package that behaves correctly (e.g. a package
that auto-generates the configure script when its inputs are modified).
Attempting to hand-tune rules to plug configure into Bazel will surely
result in *non*-reproducible builds (thought that'd be the user's fault,
of course).

There are other alternatives to software autoconfiguration as a
pre-build step. One of them is
[Boost.Config](http://www.boost.org/doc/libs/release/libs/config/config.htm),
which has traditionally been (in the BSD world) troublesome because it
relies on preprocessor conditionals. A more interesting one, which I
have never yet seen implemented and for which I cannot find the original
paper, is using fine-grained build rules that generate one header file
per tested feature.

All this is to say that Bazel should support integration with autoconf
out of the box *or* provide a similar system to perform
configuration-time dynamic checks. This has to be part of the platform
because it is difficult to implement this and most users cannot be
trusted to write proper rules; it's just too easy to get them wrong.

# Issue no. III: It's not only about the build

In the "real world of open source", users of a software package do not
run the software they build from the build tree. They typically install
the built artifacts into system-wide locations like `/usr/bin/` by
simply typing `make install` after building the package&mdash;or they do so
via prebuilt binary packages provided by their operating system.
Developers generate distribution tarballs of their software by simply
typing `make dist` or `make distcheck`, both of which create
deterministic archives of the source files needed to build the package
in a standalone environment.

Bazel does not support this functionality yet. All that Bazel supports
are `build` and `test` invocations. In other words: Bazel builds your
artifacts in a pure manner... but then... how do these get placed in the
standard locations? Copying files out of the `bazel-bin` directory is
not an option because putting files in their target locations may not be
as simple as copying them (see shared libraries).

Because Bazel supports highly semantical target definitions, it would be
straightforward to implement support for an `install`-like or a
`dist`-like target&mdash;and do so in an infinitely-saner way than what's done
in other tools. However, these need native support in the tool because
the actions taken in these stages are specific to the target types being
affected.

One last detail in all this puzzle is that the installation of the
software is traditionally customized at configuration time as well. The
user must be able to choose the target directories and layout for the
installed files so that, say, the libraries get placed under `lib` in
Debian-based systems and `lib64` in RedHat-based systems. And the user
must be able to select which optional dependencies need to be enabled or
not. These choices must happen at configuration time, which as I said
before is not a concept currently provided by Bazel.

# Issue no. IV: The Java "blocker"

All of the previous "shortcomings" in Bazel are solvable! In fact, I
*personally* think solving each of these issues would be very
interesting engineering exercises of their own. In other words: "fixing"
the above shortcomings would transform Bazel from "just" a build system
to a full solution to manage traditional software packages.

But there is *one* issue left that is possibly the biggest of all: Bazel
is Java, and Java is a large dependency that has traditionally had
severe FUD around. Many of the open source projects that would like to
escape their current build tools are small projects and/or projects not
written in Java. For these cases, introducing Java as a dependency can
be seen as a big no-no.

Java is also an annoying dependency to have in a project. Java virtual
machines are not particularly known for their portability: the "build
once, run anywhere" motto is not completely true. By using Java, one
closes the door to pretty much anything that is not x86 or x86-64, and
anything that is not Linux, OS X nor Windows. Support for Java on other
operating systems or architectures is never official and is always
unstable for some reason or another. Heck, even most interpreted
languages have better runtime support for a wider variety of platforms!
(But maybe that's not an issue: the platforms mentioned before are
pretty much the only platforms worth supporting anyway...)

The reason this is a problem is two-fold. The first goes back to the
portability issue mentioned above: many open source developers do not
like narrowing their potential user base by using tools that will limit
their choices. The second is that open source developers are, in
general, very careful about the dependencies they pull in because they
like keeping their dependency set reduced&mdash;ever noticed why there are so
many "lightweight" and incomplete reimplementations of the wheel?

So it would seem that Bazel for Java-agnostic open source projects is a
hard sell.

But not so fast; things could be improved in this area as well! It's
easy to think that Bazel makes use of a relatively limited set of Java
features. Therefore, it might be relatively easy to make Bazel work (if
it doesn't already) with any of the open-source JVM/classpath
implementations. If that were done, one could then package Bazel with
that open source JVM together and ship both as a self-standing package,
permitting the use of Bazel on pretty much any platform with ease.

# Target users

So where does all the above leave Bazel? What kind of projects would use
Bazel in the open source world? Remember that we are considering the
low-level packages that form our Unix-based operating systems, not
high-level applications.

On the one hand, we have gazillions of small projects. These projects
are "happy" enough with the autotools or the tools specific to their
language: they do not have complex build rules, their build times are
already fast enough, and the distribution packagers are happy to not
need alien build rules for these projects. Using Bazel would imply
pulling in a big dependency "just" to get... nicer-looking `Makefile.am`
files. Hardly worthwhile.

On the other hard, we have a bunch of really large projects that could
certainly benefit from Bazel. Of these, there are two kinds:

The first kind of large open source project is a project composed of
tons of teeny tiny pieces. Here we have things like X.org, Gnome, and
KDE. In these cases, migration to a new build system is very difficult
due to: the need to coordinate many separate "teams"; because there must
be a way to track build-time dependencies; and also because, as each
individual piece is small, each individual maintainer will be wary of
introducing a heavy component like Bazel as their dependency. But it
could be done. In fact, X.org migrated from imake to the autotools and
KDE from the autotools to cmake, and both projects pulled the task off.

The second kind of large open source project is a project with a unified
source tree. This is the project that most closely resembles the source
tree that Blaze targets, and the project that could *truly* benefit from
adopting Bazel. Examples of this include Firefox and FreeBSD. But
migrating these projects to a new build system is an incredibly
difficult endeavor: their build rules are currently complex and the
impact on developer productivity could be affected. But it could be
done. In fact, one FreeBSD developer maintains a parallel build system
for FreeBSD known as "meta-mode". meta-mode attempts to solve the same
problems Bazel solves regrading correctness and fast builds on a large
codebase... but meta-mode is still make and... well, not pleasant to
deal with, to put it mildly. For a project like FreeBSD, all the issues
above could be easily worked-around&mdash;with the exception of Java.
Introducing Java as a dependency in the FreeBSD build system would be
very difficult politically, but maybe it could be done? I don't know; I
guess it'd depend on the JVM being used (after all, GCC used to ship
with GCJ in the past).

# Closing

Despite all the above, I think Bazel is a great tool. It is great that
Google could open source Blaze and it is great that the world can now
take advantage of Bazel now if they so choose. I am convinced that Bazel
will claim certain target audiences and that it will shine in them; e.g.
dropping [Gradle](https://gradle.org/) in favor of Bazel for Android
projects? That'd be neat.

But the above makes me sad because these relatively simple shortcomings
can get in the way of adoption, even for test-run purposes: many
developers won't experience the real benefits of having an excellent
build tool if they don't *even try* Bazel, and if they don't try Bazel
they will fall in the trap of reinventing the wheel in incomplete
manners. We have too many wheels in this area already.

Get what I'm saying? Go give Bazel a try *right now*!

That's it for today. Don't leave before [joining the bazel-discuss
mailing list](https://groups.google.com/forum/#!forum/bazel-discuss).
And, who knows, maybe you are a "build system junkie" too and will find
the above inspiring enough to work on solutions to the issues I raised.
