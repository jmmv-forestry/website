---
title:  Introducing Nudgy Timer
date:   2015-12-17 17:30:00 -0500
categories:
  - "software"
aliases:
  - /blog/2015/12/17/introducing-nudgytimer.html
excerpt_separator: <!--end-of-excerpt-->
---

<img src="{{ "/images/2015-12-17-nudgytimer.png" | prepend: site.baseurl }}"
     alt="Nudgy Timer screenshot"
     class="float-right with-border"
     width="300px" />

For the last two years, I had been meaning to write an Android app just for
the sake of it.  I had attempted to do so in short chunks of "free time",
but that never played out well: I had to force myself to sit down for a few
hours straight to fight Android Studio and overcome the initial
difficulties in coding for an unknown platform.  That's why, during the
last Thanksgiving week, I took three days off of work to focus on writing
my first Android app.  The goal was to get a basic app that could later be
built on iteratively as open source.  The specifics of the app did not
matter much for this exercise, but I had a simple idea in mind.

<!--end-of-excerpt-->

And those three days played out really well.  After three intense days, I
had a functional application running on my phone, ready to be demoed on
Thanksgiving day!  Granted, the code was garbage and the app had some
serious fundamental bugs, but I had gotten a prototype that I could show
around.  In particular, I got the background timer working, various
activities and their workflow, some basic unit tests for auxiliary support
classes, and data persistency via SQLite.

Since then, I have been working hard on reworking the core logic of the app
to be robust, cleaning up the code, and adding some tests, all in
preparation for publishing the code so that I can continue work on GitHub
instead of in an internal "unclean" repository.

And, today, I am finally open-sourcing the **Nudgy Timer project**:

> <https://github.com/jmmv/nudgytimer/>

The app is now barely functional but I think its foundations are "good
enough" to keep building on it step by step.  The UI is suboptimal though,
so while the app might work, it will not deliver a pleasant experience.

For the time being, you can only find this app in GitHub in source form:
there are still a bunch of important to-do items to be addressed before it
can go live into the Google Play Store and be easily available.  (One of
which is for me to run the app on my real phone for a few days to see how
it behaves.)  Bear with me for a bit longer before you try it out.

Lastly: **this is my very first Android app** and the first Java code I
write since 2008.  **I would like to invite you to take a look at the
sources and be brutaly honest** about what things are not good and how to
make them better.  **Please file bugs** if you do so, and thank you!
