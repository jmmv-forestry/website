---
layout:      post
title:       The GOPATH problem
categories:  development go
excerpt_separator: <!--end-of-excerpt-->
---

In my last article, I posted a review of the Go language from the perspective of a newcomer. The very first thing I classified as bad was `GOPATH` and, as I could predict, readers were eager to dispute this claim.

The counterarguments were along two lines: first, that having `GOPATH` is not bad: it's just *different*; second, that I do not "get" the "Unix way"; and, third, that it's as "easy" as adding a line in your shell profile to "fix" the problem. Ha ha. Oh you are serious? Let me laugh even harder. Ha ha ha.

Here is my rebuttal.

<!--end-of-excerpt>

# Why is `GOPATH` wrong?

Short version: because requiring an environment change so that things work is stupid. The majority of other software pieces that exist do *not* require this kind of tweaks and they work just fine. They can be made to work.

You see: I have been packaging software for many years, and a fundamental expectation of a software package is to work "out of the box" as soon as you type `foo install bar`. If the package requires a post-installation message to tell the user or system administration how to further set things up for the package to work, the package is suboptimal.

But, but, the package installer could modify your configuration! Sure it *could*, but that's hell. Do you modify the system-wide configuration or the user-specific files? How do you apply the change? More importantly: how do you *undo* the change at deinstallation time? Any of these two are very difficult to achieve, in particular if you want to respect the property that uninstalling a package should leave the system exactly as it was before.



# Rebuttal

# Possible alternatives
