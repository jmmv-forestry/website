---
layout: post
title: "Self-interview after leaving the NetBSD board"
date: 2013-06-20 12:00:00 -0400
categories: featured netbsd
julipedia: 2013/06/self-interview-after-leaving-netbsd.html
---
*The decision to **not** renew my NetBSD board membership was
bittersweet.*

Let me put aside the [Readability
series](http://julipedia.meroh.net/search/label/readability) posts for a
moment while I recap how the two years serving the NetBSD Board of
Directors have been. My term just finished a couple of weeks ago, so it
is better to post this while it is still relevant.

First, let me backtrack a little bit. A couple of years ago, I was
nominated to serve the NetBSD Board of Directors. Needless to say, I was
flattered that this was the case so I decided to run for the position.
This worked, so "soon" after [I joined the board in May of
2011](http://julipedia.meroh.net/2011/05/joining-board-of-directors-of-netbsd.html).

Board memberships last two years, and the members whose terms are about
to expire can opt to run for a renewal. I chose not to do so, mostly for
the benefit of the project. I had lost pretty much all the time I could
devote to the board to the point where I was regularly missing meetings.
The real reason, though, is that I had become unmotivated, and that was
what most certainly translated into not "having" time &mdash; as the saying
goes, people make time for the things they really care about... so go
figure.

If this was a "real job" I would have gotten an exit interview from the
human resources (HR) department. But because there was no such a thing
(hey, maybe there should have been one? There goes an idea), I'm
publishing my own thoughts here. Just keep in mind that *everything that
follows is my personal opinion*.

------------------------------------------------------------------------

Let me make this very clear upfront: I *do* have a lot of respect for
the vast majority of the people involved in NetBSD: most of them, if not
all, are highly competent and, to the extent I can tell, nice people. I
am not going to point fingers at anyone in particular in what follows
below, if only because no individual is "at fault".

However, having competent and nice people in the project is orthogonal
to the project being on a path that could eventually lead to *widespread
success*: the project has actually been moving fast in the opposite
direction and denying so is burying the head in the sand. But, hang on:
what do *I* mean by "widespread success"? I mean a project that is truly
competitive in the specific market it chooses to be in; a project in
which we can innovate and not constantly worry about politics; a project
that external people don't consider dead, archaic or obsolete; a project
that has good recognition in the open source world; a project that
continuously attracts new talent to maintain enough "critical
development mass"; a project with a really well-defined set of goals
that motivate the users and developers involved in it; a project in
which contributions that don't fit the set goals can quickly,
unambiguously and explicitly be rejected; a project with strong
direction to set and maintain these goals; and a project that has enough
developers to not struggle with keeping up with modern hardware or
software. Wow; that's not an exhaustive list, but I hope is enough to
clarify what follows below.

Some of you will surely disagree with my take on what being successful
means, but if that's the case, I'd like to ask you to continue reading
anyway. Also, no matter how successful the project is in the future, and
no matter what definition of "success" you use, the code of the NetBSD
operating system will always be "out there: and it will always be the
perfect system to fill the hands of a minority. But this shy and
non-ambitious position is not why I am here for.

It is heartbreaking to see that, as years pass by, NetBSD becomes less
and less relevant in all the areas I mentioned above... and, what is
worse: nobody is able to take action because all attempts to effect
major change derail into a frustrating experience (both for longtime
developers and newcomers). As a specific example: every year, the NetBSD
Foundation runs a group meeting with all the members of the foundation
as per its bylaws. Such meeting is always started by a talk from a
member of the board. Years ago, circa 2003, such talks were incredibly
motivational: the leaders had a strong sense of where the project was
going and what it needed to get there. As years have gone by, such
presentations have turned into a quick summary of what happened over the
last year, without a single mention of "what's next".

Enough generic talk. It's time to get into specifics, so here are my
main concerns: *there is no **leadership** in the project, there is no
willingness to take **risk** and there is fear to **recruit** new users*
who may have different points of view. These make me incredibly sad for
a project that I have had in my heart for the last 11 years.

Let me elaborate on these points one by one.

# Lack of leadership

Theoretically speaking, there are two major groups that are *supposed
to* lead the project: [the board](http://www.NetBSD.org/foundation/) and
[the core team](http://www.NetBSD.org/people/core.html). The idea is
that the board is in charge of administrativa around the project, doing
things like managing donations, deciding on a budget, dealing with legal
issues, etc.; and then there is the core team, whose responsibility is
to lead the technical aspects of the project. That's the theory, and
yes, the two teams do exist.

In practice, however, these teams are dysfunctional because they do not
provide leadership: all they do is *act reactively* to requests from
users and/or to resolve internal disputes. In other words: there is no
initiative nor vision emerging from these teams (and, for that matter,
from anybody). There are some minor exceptions though, like proposing
technical projects to fund, but... that's pretty much it.

Digging further, the split between board and core hurts the project more
than it helps. NetBSD *is* a technical project, and thus all leaders
should keep that in mind. Having two set of independent leaders at the
same "organizational level" is detrimental, if only because getting them
to agree (which involves 13 people today) is extremely difficult and
will always result in too many compromises no matter what the decision
to make is.

My point of view is that there is a need for a reduced and single set of
strong leaders willing to take risk (as I'll soon describe below), and
maybe even the need for a *single* strong leader. Karl Fogel describes
these [two management
structures](http://producingoss.com/en/social-infrastructure.html)
pretty well in his "[Producing Open
Source](http://producingoss.com/en/index.html)" book (which you should
read right now if you haven't done so yet, by the way).

# Inability to take risk

When I say "taking risk" I am talking about the ability to make strong
decisions that may be controversial; decisions that could make some
members leave the project &mdash;out of their own will, of course&mdash; while at
the same time empower others to move their vision forward.

As things are today, the project leaders will almost always settle for
either the conservative solution or a solution that compromises on every
detail so as to not annoy anyone. Unfortunately, this approach
*implicitly* disappoints a group of people &mdash; a group of people that may
not be vocal enough to express their preferences out of previous
disappointments. All of this, of course, only happens when the leader
teams are asked about something, as they will rarely provide input
unless asked for (see reactive model above).

There are plenty of examples about this, and I do not want to go into
the specifics of each. However, because I want to make my points
concrete, I will mention a couple of recurrent items that have been
ongoing for years and that will certainly continue to be the same for
years to come: the ditching of CVS and the renewal of the web site. The
details, again, are not important for this discussion; what is important
is to say that there is a general apathy towards these topics in the
project.

But let's just take the migration away from CVS as an example. The
current view on the topic is that no existing VCS can replace CVS and
keep some of the properties that CVS has. Therefore, if we were to
switch away from CVS, a bunch of developers attached to those old
properties would possibly abandon the project. That's a fine concern,
but the thing is that CVS is not perfect either and many developers
would be *way more productive* if we were using something different.
These developers possibly contribute less by this fact, and new
developers may not wish to contribute after knowing the project still
uses arcane tools. (Have you tried telling anyone in person that NetBSD
still uses CVS? No? Try it and observe their faces.) So here we have the
dichotomy: we either change to a different system acknowledging a few
deficiencies and explicitly annoy a few people along the way, or we
change nothing and we silently shoo existing and new developers away.
Guess which one will always win.

My little pet peeves on this topic came right after BSDCan 2012. During
the conference, a few outsiders, other NetBSD members and I discussed
these very same topics: how to prevent the project from becoming even
more irrelevant, how to move some of the stuck decisions forward, and
some other topics for which we just needed a firm commitment to make
them happen.

As a result of these conversations, the first thing I did was to write a
pretty long and provocative critique of what was wrong with NetBSD and
what needed to change to fix it. My plan was to publish it in the blog,
but later decided to just send it to the board for internal discussion &mdash;
hoping that keeping things private and in a reduced group would lead to
a healthier discussion. Unfortunately, my email was received partially
with anger and partially with apathy. (If any of you are reading this,
please note that this was never my intention. What I wanted to achieve
with that long post was to motivate us to directly address recurring
difficult challenges, just like I'm trying to do here now. It is
possible that the wording at the time was not appropriate.)

One other thing we discussed during BSDCan 2012 was the creation of a
*[mission statement](http://en.wikipedia.org/wiki/Mission_statement)*.
Every organization should clearly know what its goals are and it should
have priorities on which to base their controversial decisions. Right?
Right.

So the second thing I did was to propose the creation of a mission
statement (which, turns out, had already been proposed by another board
member a few years back). This idea was quickly met with reluctancy,
with the rationale being that it was not possible to come up with a
useful mission statement that covered all users of NetBSD. The thing is
that it is obvious that NetBSD (or for that matter any software project)
*cannot* be everything for everyone: one way or another, some use cases
and/or user profiles are going to be left out. Eventually, though, we
settled on surveying the user base to see what our user profiles were
and what such users wanted NetBSD to be, which is actually a good first
step to define a mission statement that does not alienate everybody.

What happened soon after was surreal. Deciding what you want the survey
to expose is hard. Coming up with a meaningful survey is tough and
having a set of questions from which you can later derive reasonable
conclusions is difficult. But, hey, the whole point of running a survey
is to get to those conclusions. However, the discussion(s) ratholed into
deciding what the best *software* to perform the survey was, losing all
perspective on why we wanted to do this and what kind of information we
wanted to gather. In the end, this whole thing died off because the
board was not bought into the idea that defining a path for the project
was an important thing to do, and I got tired of pushing this forward;
so, yes, I'll take the blame for this not happening. To this day,
nothing has happened in this regard and NetBSD continues to be a project
without strong goals to distinguish itself from the competition and to
make newcomers believe in its future. Which brings me to my next point.

As a side note, let me briefly mention why I believe a mission statement
is a must have. First, because it clearly tells users what the project
is about and what they can expect from it. And second and more
importantly, it sets the ground rules on the kind of contributions that
are acceptable: if a developer proposes a change that does not fit the
mission, the change can quickly and explicitly be denied. There is no
emotionally-draining arguments and thus no hard feelings arise. Granted,
said developer may leave the project, but in the long term he will be
happier because he'll direct his energy towards a project that is
aligned with his personal goals.

# No desire to recruit new users

Users. NetBSD needs more users, lots more of them. Why? Because a small
percentage of those new users will become new fresh contributors with
energy, and they will help the project. The more developers, the better
NetBSD will be able to keep up with current times and the more users
there will be, which in turn will allow us to work on bigger and more
innovative projects. It's a vicious circle, and it's one that has been
shrinking for many years already: we keep losing developers and users,
we cannot keep up with the times, and therefore we don't get new users.

But that's not the problem. The problem is that some vocal project
members do not *want* to attract users. They are happy with the current
reduced and shrinking user base as long as they can continue to hack on
their favorite stuff. (I know, I know, it's hard to quantify "shrinking
user base" in an open source project such as NetBSD, but I think it's
pretty obvious to anyone that has been involved with the project for
years that this is the case. And if it isn't obvious, it should be.)

The general belief is that by making an technologically good product,
NetBSD will attract talent and reach critical mass. I'm sorry but: *Not.
Going. To. Happen.* As recently mentioned in a mailing list: if having
excellent technology were enough to attract new users, NetBSD should
have tons of those already; after all, it has been 20 years since the
start of the project. Where are these users? If anything, we have lost
the majority of the ones we already had.

This is nothing new. If you look at the industry &mdash;any industry&mdash;, you
will find products that were years ahead of their times and better than
the competition. Yet, they failed. The less advanced products did a
better job at reaching out to their potential users, they gained marked
share, and they killed the better competition. Betamax anyone?

I am not going to say how NetBSD could avoid scaring new users away;
this is out of scope of this post. But there are many ways, ranging from
marketing efforts to the definition of firm goals, passing by changes to
the project's infrastructure.

# Parting words

In 2006, another ex-board member posted his own thoughts on the state of
the project, some of which line up with what I've written above, some of
which I don't agree with. At that time, [I could more or less
see](http://julipedia.meroh.net/2006/09/letter-to-netbsd.html) where
those concerns were coming from. Now it's 2013 (that's **7 years**
later) and little has changed since; if only, some aspects have only
gotten worse.

This all makes me incredibly sad. NetBSD is still the open source,
Unix-like operating system that bothers me the less and the one I like
hacking on. It is the open source project in which I acquired tons of
"real-world" engineering skills. Because of these, I'm not "quitting"
the project; at least not yet. However, and unfortunately, I'm finding
it harder and harder to get the energy to contribute to NetBSD: there
are many more rewarding things to do out there in the open source world.

So after all this you may still be wondering: "why bittersweet"? The
decision was bitter because I enjoyed the feeling of being part of the
board. It was also bitter because I saw I could not make any substantial
change even if I renewed my membership. It was sweet because I could
finally let go and allow more energetic people take my place, hoping
that they manage to do a better job.

I wish good luck to the current board and core members. My hope with
this post is to hopefully inspire someone in the project to take strong
action and stir it in the right direction, whichever that might be. The
project just needs ***a*** direction, and whoever is able to define that
will win big time.

Thank you for reading, and I hope you take this as a sincere and
constructive criticism.
