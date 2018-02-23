---
title:      Those pesky Makefiles
date:       2016-03-02 09:45:00 -0500
categories:
  - "software"
medium:     those-pesky-makefiles-4784d4dc4888
aliases:
  - /blog/2016/03/02/those-pesky-makefiles.html
slug: those-pesky-makefiles
---

As a software developer, you have probably disregarded the build system of your project---those pesky `Makefile`s---as unimportant. You have probably "chosen" to use the de-facto build tool `make(1)`. And you have probably hacked your way around until things "seemingly worked".

But hang on a second. Those build files are way more important than you may think and deserve a wee bit more attention.

<!--more-->

# What if... you lost them?

Let's start with an exercise, one that I heard many years ago when [parts of the Windows 2000 source code were leaked](http://news.microsoft.com/2004/02/12/statement-from-microsoft-regarding-illegal-posting-of-windows-2000-source-code/). **What if you received massive amounts of source code without the build files?** Could you be able use that code again? "Of course" you *could*, but it would take an extraordinary effort to make the pieces work again as originally intended. It would be even harder to recover the intended state if the original build system allowed any kind of customization---think building for different production or test environments---or had, say, cross-building functionality. And you could even be introducing new run-time bugs by getting the build wrong!

The reason this came to mind is because I spent all of last month fighting build rules to make [Bazel](http://bazel.io/) build itself on a newly-supported environment. A month of fiddling with build rules and small portability fixes; a month without writing any substantial code.

Well, in reality I "only" spent a whole week ploughing hacks to make this happen... but then I spent the other three weeks cleaning up the hacks so that I could check them in. It was one thing to prove that the end goal was attainable, and it was a very different one to actually reach that goal in a reasonable manner. Extending build rules that work under multiple scenarios and that target different platforms is hard, especially while keeping existing functionality stable.

Another reason this came to mind is that, recently, I have been toying with writing a Go Appengine app. Running the trivial "Hello World" sample is easy: type some code in `.go` files, run `goapp serve`, and boom: the app (re)compiles in the background and is served on the web. Good? No.

Unfortunately, as soon as you start writing "the real stuff", you end up requiring features not provided by the simplistic and basic toolchain. You may need to fetch dependencies depending on the developer's needs; you may need to build auxiliary tools to set up the production environment; you may need to run those tools with specific flags for your project and for the developer machine; you may need to interact with the VCS system to install hooks and get those working; etc. All these require some form of plumbing, which I chose to do via `make(1)` and a hand-tuned `configure` script---purely out of routine, not because these are great tools---and they have grown more than originally expected.

# Writing build files is... hard

Build systems are complex beasts and the average developer should not have to---or, in fact, does not want to---care about them. Regardless, most developers *have to* end up writing build rules for the software they write (who else would?) and they do so without understanding the fundamentals of the tools nor the implications of their code.

Take, for example, `configure.ac` scripts. GNU Autoconf has [excellent documentation](http://www.gnu.org/software/autoconf/manual/index.html)---and reading through it is a humbling exercise, *especially* if you are ever so tempted to write your own "simplified" configuration tool. (Spoiler: *don't*.)

Anyway: the vast majority of (open source) projects end up requiring a `configure.ac` script... but the developers, understandably, won't go through the hassle of learning all the details of Autoconf because writing a configuration script is not their goal: it's just boilerplate. The end result is that the developers copy/paste other people's scripts and/or snippets from shabby sources. Repeat this copy/paste process over a handful of projects and you end up with a Frankenstein-like configuration script that can barely stand on its own. Yet, it *seems* to work on the developer's machine, and therefore gets shipped to the world... only to cause pain down the road.

The same applies to any script used to maintain the project. Think of the auxiliary scripts that invoke continuous tests under Travis, the scripts to sanitize your source tree, the scripts to package your software, or even your installation script. Because these are not part of the project's "core functionality", they are often thought as unimportant and are just hacked away. Just keep in mind that those scripts *will* fail due to their poor quality, and it's no fun at all when they do so at, say, release time.

# Stick to conventions

So how do you minimize the danger of hurting yourself? *Do not reinvent the wheel.* **Stick to existing tools and conventions.**

If you think your project is special enough to warrant a hand-tuned build system, think again. Writing your own build system is a recipe for disaster: first, because you are throwing away *the collective* wisdom of the people that wrote the existing tools; and, second, because you immediately make your package unbuildable out-of-the-box by any existing packaging system.

Let's see some examples on the lots of conventions that exist: support for environment variables (`CC`, `CFLAGS`, `CPPFLAGS`, et. al.) and how they are later passed to the compiler, the linker, and the preprocessor; specific build targets that should exist (`all`, `install`, `check`, and the myriad required by the widespread [GNU Coding Standards](https://www.gnu.org/prep/standards/standards.html#Makefile-Conventions)); the tools that you should end up invoking (e.g. `install` instead of plain `cp` to put your files in the destination location); the hierarchy of the installed files and the ability to tune the layout depending on the platform; support for build directories separate from the source tree; support for cross-compilation; support for dynamic detection of compiler and system features; and a long etc.

Note that the examples above only scratch the surface: I focused exclusively on what your standard software package for a Unix system would need, and nothing else. Take an interpreted language instead of C or C++ and, suddenly, the conventions are all different.

The problem here is that users of your package *expect* all these things to "just work" based on established conventions. If you change those conventions intentionally or just out of knowledge, your package will not behave as the user expects. And if that's the case, can you guess what the user will think? *Your software is broken.*

# Which conventions?

OK, so we need to follow conventions. Which ones? As always, it depends. It depends on the project you are writing, it depends on your target environment, and it depends on who your users will be.

There are dozens of build systems and each has gained a specific niche so you need to stick to your niche's preferred set of tools. To name a few: if you are writing a low-level system package, or your package uses C/C++, use the GNU Autotools; if you are writing a Python package, stick to `distutils` or `setuptools` and PyPI; if you are writing a KDE component, use CMake; if you are writing an Android app, choose Android Studio and Gradle; if you want to go fancier and the Java requirement is not a concern, consider Bazel (really, it's cool!).

You may or may not like the conventions of the tools used in the area you are working on, but you are better off by following the conventions than going against them: you'll waste fewer time and your users will be happier. E.g. personally, I do not like how the standard way of using the Autotools is by shipping massive generated scripts, or the "strange" behavior of Python's `setup.py` scripts... but I just use these in my software because they are what people---and, more importantly, packagers---expect.

This doesn't mean the tools we have today are good; in fact, many aren't. But if you spend a few minutes to learn about the shortcomings of your tools and how to make better use of them, the results will be palatable. Give the same care you give code to the build files of *your* project.

To conclude, follow onto the excellent-but-extremely-long article titled [So you want to write a package manager](https://medium.com/@sdboyer/so-you-want-to-write-a-package-manager-4ae9c17d9527). It does not talk about build systems per se, but it sheds light on the many complexities of managing a source tree and its dependencies, and how those should be hidden away from the developers.
