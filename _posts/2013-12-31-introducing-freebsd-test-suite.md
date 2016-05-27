---
layout: post
title: "Introducing the FreeBSD Test Suite"
date: 2013-12-31 08:00:00 -0500
categories: featured freebsd kyua testing
julipedia: 2013/12/introducing-freebsd-test-suite.html
---
[I joined the FreeBSD committer
ranks](http://julipedia.meroh.net/2013/11/joining-freebsd-committer-ranks.html)
a couple of months ago with the intention to equip FreeBSD with an
out-of-the-box test suite and with a testing infrastructure. The time
until now has been quite fruitful and I have been rushing to get
something ready for you before the year end.

With that, I am very pleased to announce that the first mockup of the
FreeBSD testing cluster is up and running! Point your browser at:

> <http://kyua1.nyi.freebsd.org/>

and witness the still-very-rudimentary reports. This is where the real
hard work starts: Kyua needs major changes to make these pages pretty
and truly usable.

# Current status

So where are we at? The [Test Suite project
page](http://wiki.freebsd.org/TestSuite) contains all the relevant
details but let me sum them up for you.

Both HEAD and stable/10 have got the test suite build infrastructure in
place &mdash;unfortunately couldn't make it for 10.0-RELEASE's prime time&mdash; and
some tests enabled. If you build and install any of these two releases
with the `WITH_TESTS` knob enabled in `src.conf`, you will end up with a
`/usr/tests` hierarchy in which you can run Kyua to automatically test
the live system. See `tests(7)` for details.

Kyua is currently pretty good at letting you build and test code in a
single machine. However, it is still a poor test harness because it
cannot coalesce build logs and test results into a single location for
consolidated reporting. This is why the main status page of the test
suite is quite "simple" (to put it mildly) and the individual reports
for each test run are all disconnected from each other. Mind you: the
glue required to get all the above up and running ([see
autotest](http://svnweb.freebsd.org/base/user/jmmv/autotest/)) is
non-trivial &mdash; and that's a bug! Improving this area is very high up in
the priorities list and [work is already
undergoing](http://julipedia.meroh.net/2013/11/three-productive-days-on-kyua-front.html).

The current test suite is not clean as you can see in the reports. Some
tests are broken and they must be fixed. *Accepting breakage as the norm
is dangerous*: people get used to the mindset of "one more broken test
doesn't hurt" and the test suite becomes useless.

And, of course, the current coverage of the test suite is really poor.
Once the test suite is clean, we can start integrating existing tests
and maybe porting over other tests from NetBSD. This is something I am
now finally comfortable with given that, with the continuous test
machine up and running, any migrated tests will run on a constant basis
and report their output.

# Learn live

AsiaBSDCon 2014 is the first major BSD conference of the year, coming to
you on March 13-16. I submitted a tutorial proposal to teach attendees
how to best use the test suite and how to port and/or implement new
tests for it. If all goes well and it is accepted, register to visit
Tokyo and learn about this work.

Next up is BSDCan 2014, coming on May 14-17. I also have a talk
presentation on the works for this one, so maybe you will have to come
to Ottawa.

# Want to help?

The easiest way to help is *to improve the test suite!* (not the
infrastructure)

-   Fix existing tests. Skim through the list of
    [broken](http://kyua1.nyi.freebsd.org/head/data/0-LATEST/results/index.html#broken)
    and
    [failed](http://kyua1.nyi.freebsd.org/head/data/0-LATEST/results/index.html#failed)
    tests and figure out a way to make them pass.
-   Plug old-style tests into the build. The easiest way to do this
    today is by getting the tests in `src/tools/regression/` and
    adapting them to the new layout. No code changes should be required.
    Use [r259210](http://svnweb.freebsd.org/changeset/base/259210) as
    a model.
-   Port NetBSD tests. [Garrett Cooper's
    repository](https://github.com/yaneurabeya/freebsd) and [Simon J.
    Gerraty's
    repository](http://svnweb.freebsd.org/base/projects/bmake/) contain
    many of these already, so it is a matter of copying the code,
    plugging it into HEAD and ensuring it works. Of course, any
    old-style tests that match these must be removed along the way.

Documentation may be lacking in some areas, but I hope the examples in
`src/share/examples/tests/` and the text in the project page are
somewhat useful. If you have any questions, do not hesitate to ask.

Don't miss out on the [announcements to the
freebsd-hackers](http://lists.freebsd.org/pipermail/freebsd-hackers/2013-December/044009.html)
and [freebsd-testing mailing
lists](http://lists.freebsd.org/pipermail/freebsd-testing/2013-December/000109.html)
as well as the [the Twitter
conversation](https://twitter.com/jmmv/status/418007309848432640).

That's all folks, at least until 2014. Have fun entering the new year!
