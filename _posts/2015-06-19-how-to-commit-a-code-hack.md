---
layout:      post
title:       How to commit a code hack and not perish along the way
date:        2015-06-19 12:00:00
categories:  best-practices development essay software
medium:      how-to-commit-a-code-hack-and-not-perish-along-the-way-7059dac49df6
cover-image: 2015-06-19-header.jpg
---

**You are the developer in charge to resolve a problem and have prepared a _[changelist](http://svnbook.red-bean.com/en/1.7/svn.advanced.changelists.html)_ to fix the bug. You need the changelist to be reviewed by someone else before checkin. Your changelist _is_ an ugly hack.**

**What kind of response are you gonna get from your reviewer?  Well as with everything: _it depends!_**

(Cover image courtesy of <http://www.startupstockphotos.com/>.)

* * *

If you have:

1. clearly stated upfront that the changelist _is_ a hack,
1. explained _how_ it is a hack,
1. _justified_ that the hack is the right thing to do at this moment, and
1. outlined what the _real solution_ to get rid of the hack would be

_then_ your reviewer will most likely just accept the change without fuss (!) and will proceed to review its contents per se. But if you miss _any_ of those steps, then your reviewer is going to be super-critical about your changelist _and_ any further related changes you may want to commit.

* * *

The purpose of this essay is to elaborate on the guidelines shown above. To do so, I will attempt to justify why these guidelines are important and why following them from the ground-up is a recipe for a more pleasant review process.

As we shall see, the ideas discussed in here apply equally to any changelist that might cause the reviewer to question fundamentals about your change or your knowledge of the system. Such changelists include:

* bug fixes that do not address the real root cause of the bug;
* the implementation of new features without respecting the fundamental architecture of the project;
* or the disregard of well-established development practices in your organization such as not providing unit tests or dumping huge amounts of code developed "in the dark" into the main tree.

To keep the rest of the text simple, **I will focus exclusively on changelists that attempt to "fix" a bug without addressing the root cause of the problem**.

# Let's dive in

## i) Understand the problem

Question: Are _you_ aware that your proposed fix is a gross hack?

If you do, great: you are already on the right track! If you do not, then you are [missing details](https://en.wikipedia.org/wiki/DunningKruger_effect) on the problem at hand---and missing details when fixing a bug is dangerous because: you probably won't fix the root cause; your "fix" may obscure the problem in most cases, but not all; or your "fix" may be introducing other bugs or changing the semantics of the code logic.

**To the reviewer:** everything stated here applies _equally_ to you. If you lack fundamental knowledge on the codebase in which the change is being made, _you are not qualified to review the change_ because you cannot predict its ramifications throughout the system. Find someone else to act as (secondary) reviewer---assuming "that someone else" exists and is still available which is not always the case.

Checking in code developed under these circumstances is harmful in the medium to long term. Do not check in code if you or your reviewer do not have deep knowledge of the system to predict the effects of the fix. And always try to pick reviewers that will be strict on this topic!

## ii) State upfront that the change is wrong

If you know your changelist is a hack, mention this fact upfront in the changelist description.

If you do not, then your reviewer can assume any of the following: that you do not know your change is a hack (back to step _i_); that you do not think submitting the hack is a bad idea (when common sense would say otherwise); or that you just want to sneak in a bad change due to laziness (maybe?).

None of the thoughts above sound good, do they? Correct! And that's why if they cross your reviewer's mind you will receive much additional questioning.  Don't let that happen: clarify things upfront to avoid getting into this situation.

## iii) Explain upfront why the change is wrong

Just as important as it is to acknowledge that a change is a hack is the fact of explaining _why_ it is a hack. Explaining why, preferably in the changelist description, clearly demonstrates that you understand that you changelist is not the greatest solution and that you can predict the implications of your ugly change.

## iv) Justify checking in the suboptimal changelist

Explaining why the changelist is wrong is not sufficient, unfortunately. You still need to convince your reviewer that your suboptimal changelist is the right thing to do at this point in time---and if you are submitting a changelist for review that you _know_ is "incorrect", you will surely have reasons for doing so. Say them!

Reasons for checking in a suboptimal changelist may include: mitigating the effects of an outage when the root cause has not yet been identified or when fixing the root cause is a major effort; being able to deliver a feature sooner; setting up a transitional state for some other upcoming code; or applying a temporary change that will soon be removed by a refactoring.

Remember: we are engineering solutions to problems and, as is often said: "engineering is the science of tradeoffs". Many times, all things considered, a hack is the best approach to resolving the problem at hand. All it takes to commit such hack is to detail your train of thought and to convince your reviewer that it is indeed the right thing to go.

## v) Detail what the real solution would be

Having justified why you want to submit a hack, you should go the extra mile by _filing a bug_ and _adding a TODO to your code_ detailing what it would take to fix the problem properly.

Explaining your preferred real solution, in broad terms, demonstrates that you fully understand the effect of your hack and that you have a mental plan on how it would be removed in the future.

Mind you: having this mental plan is essential because knowing how the future will look like guides you in implementing the hack in a less obtuse way. A hackish changelist can have many forms and, usually, if you know what will follow later to get rid of it, your hack will be easier to digest. For example: your hack may be localized in a single file for easy removal in a follow-up changelist or, the opposite, it may be abstracted in such a way to not get in the way of regular development.

# Simply put

* Be honest and transparent about why you are writing a changelist in a specific way.
* Acknowledge upfront that the change you want to submit is not the best for reasons X, Y, and Z.
* Demonstrate your full understanding of the issue by justifying the tradeoffs of committing your hack and explaining how you'd get rid of the hack in the future.

These are the secrets to a smoother check-in process---even for those changes you will eventually regret. Do them and hope for an:

> _LGTM. You'll burn in hell for this._
