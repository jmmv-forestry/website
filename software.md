---
layout: page
title: Software
permalink: /software/
---

As an open source enthusiast, I have authored and maintain a few projects of my
own.  You can get details on the majority of these by visiting my [GitHub
profile](https://github.com/jmmv/) and my [OpenHub
profile](https://www.openhub.net/accounts/jmmv).  The following is just a sneak
peek of the projects I started:

<div class="row">
  <div class="col-md-6 text-center">
    <a href="https://github.com/jmmv/">
      <img src="{{ "/images/badges/GitHub-Mark-32px.png" | prepend: site.baseurl }}">
    </a>
  </div>
  <div class="col-md-6 text-center">
    <a href="https://www.openhub.net/accounts/5130?ref=Detailed"
       target="_blank">
      <img alt="Open Hub profile for Julio Merino" border="0"
           height="35" width="230"
           src="https://www.openhub.net/accounts/5130/widgets/account_detailed.gif"></img>
    </a>
  </div>
</div>

## Authored projects

* **[Boost.Process](http://www.highscore.de/boost/process/)**: A flexible
  framework for the C++ programming language to execute programs and manage
  their corresponding processes.  This was a project developed under the Google
  Summer of Code 2006 program and was later picked up by another developer who
  maintains it to this day.

* **[etcutils](http://www.netbsd.org/~jmmv/etcutils/)**: Standalone utilities to
  manipulate some of the configuration files in `/etc` in a programmatic manner.
  Designed to be integrated into packaging systems as a lightweight dependency.

* **[Kyua](http://github.com/jmmv/kyua/)**: A testing framework for
  infrastructure software.  This is my star project and the one where I spend
  most of my (very little) free time in.  Kyua is used, mostly, by FreeBSD to
  run its operating system-wide test suite.  Kyua's parent project,
  [ATF](http://github.com/jmmv/atf/), was developed under the Google Summer of
  Code 2007 program.

* **[Lutok](http://github.com/jmmv/lutok/)**: A lightweight C++ API library for
  the Lua programming language.  Lutok provides thin C++ wrappers around the Lua
  C API and makes extensive use of RAII to prevent resource leakage, exposes
  C++-friendly native data types, and reports errors via C++ exceptions.
  Originally developed as part of Kyua but split into its own project due to
  popular demand.

* **[Markdown2Social](http://github.com/jmmv/markdown2social/)**: Converts
  simple Markdown documents to Google+ posts.  Written in Python.

* **[Shell Toolkit (shtk)](http://github.com/jmmv/shtk/)**: Application toolkit
  for programmers writing POSIX-compliant shell scripts.  This is a simple
  collection of shell functions to simplify the implementation of user-friendly
  command-line utilities.

* **[sysbuild](http://github.com/jmmv/sysbuild/)** and
  **[sysupgrade](http://github.com/jmmv/sysupgrade/)**: A couple of utilities to
  build NetBSD from source and to upgrade a running NetBSD system.  I hate
  executing procedures that involve more than one step by hand, so *I have to*
  automate them.  These two tools are just two of many examples.

* **[tmpfs](http://netbsd-soc.sourceforge.net/projects/tmpfs/)**: An efficient
  memory file-system, originally for NetBSD (2005) and later ported to FreeBSD
  (2008).  This was a project developed under the Google Summer of Code 2005
  program.

* **[XML Catalog Manager (xmlcatmgr)](http://xmlcatmgr.sourceforge.net)**: A
  small utility manipulate SGML and XML catalogs.  Designed to be integrated
  into packaging systems as a lightweight dependency.

## Contributions to existing projects

I have also contributed significantly to the following projects:

* **[Colloquy](http://colloquy.info/)**: An IRC client for Mac OS X.  Back when
  I decided to fully switch to this operating system for my desktop machine, I
  was connecting to NetBSD's chat network, which uses the ICB protocol.  In
  order to have a "pure" OS X experience, I added ICB support to Colloquy and
  along the way learned the basics of Objective C and Xcode.</li>

* **[FreeBSD](http://www.freebsd.org/)**: General-purpose Unix-like, free, open
  source operating system with a focus on performance and usability.  I have
  been a committer since 2013.  My work has focused on the implementation of
  [The FreeBSD Test
  Suite](http://julipedia.meroh.net/2013/12/introducing-freebsd-test-suite.html).

* **[Gnome](http://www.gnome.org/)**: Desktop environment for Unix-like systems.
  I originally ported Gnome 2.x to the NetBSD operating system and was the sole
  maintainer of the resulting packages for a few years.  As a result of this, I
  contributed countless patches upstream to address portability issues.

* **[NetBSD](http://www.netbsd.org/)**: General-purpose Unix-like, free, open
  source operating system with a focus on correct design and portability.  I
  have been a committer since 2002 and served as a board member for two years.
  Most of my work has been on [pkgsrc](http://www.pkgsrc.org/), the NetBSD's
  packaging system, but I have also laid the foundations of the NetBSD test
  suite and have developed the tmpfs file system.
