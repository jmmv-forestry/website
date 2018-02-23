---
title:      The Medium experiment wrap-up
date:       2016-01-28 22:30:00 -0500
categories:
  - "blog"
  - "writing"
aliases:
  - /blog/2016/01/29/medium-experiment-wrapup.html
slug: medium-experiment-wrapup
---

Eight months ago, [I decided to try
Medium]({{< relref "2015-05-24-hello-medium.md" >}}) as the platform on which to
post my essays.  Over this time I have published a handful of posts in
there---8, to be precise, which is... a very shy number---but the
results have been quite satisfactory: the WYSIWYG composer is excellent,
the analytics tools are simple but to the point, the looks are great, and
the community is nice (though I haven't been able to tap into it just yet).
But where have things failed?

# The failure

Regardless of all the good things, the experiment overall has failed.  To
summarize it:

> Medium has _failed as the place where I want to post my articles
> **first**_ though it remains a _great **secondary** place for content
> redistribution and promotion_.

Let's go over the reasons.

## Post classification

The first problem I have with Medium, which is a minor one, is that *I* see
it as a place for high-quality, large-form essays---not the average
blog post with the musings of the day.  In other words: I see myself
posting long opinion pieces (as I have done) and not something like the
announcement of a new release of a personal project or incomplete thoughts
on a topic.  In turn, this means that I have restrained the kind of content
I have posted there and thus not been able to completely replace my blog.

It's completely true that *this is my own point of view* and I'd just need
to let go of it and post more.  But there is an implementation detail of
Medium that bothers me enough to prevent me from doing this, and it is a
simple one: **posts cannot be classified**.  As a result, as soon as you
start posting short replies to other people's posts, your own profile gets
cluttered with such replies-as-first-class-posts and your original,
long-form content gets lost in the noise.

It would be great if Medium provided a mechanism to say "show these and
those stories on my profile, but nothing else" so that you could carefully
craft what you want displayed on your persona.  Otherwise it is hard for
readers to see what other good stuff from you they may consume.  Maybe a
publication is the answer to this, I don't know, but I don't really want
to dig further because of the second problem.

## Data liberation

The second problem, and this is a much more serious issue, is about data
liberation.  If you write first on Medium, your posts are stuck there
*unless you put significant effort to take them out*.

But why is so?  After all, it's just text!  Well, you see... Medium
provides functionality to export your content, but the exported posts are
unusable garbage: the exported HTML can be read on a browser and it renders
similarly to what you could view originally in Medium, but that's about it.
The HTML is littered with unnecessary tags, and to prove that suffices to
say that the exported HTML for a post takes *double the space* than the raw
text.  As a result, the exported copies are unusable for anything else
should you ever want to reuse *your text* for other purposes or in other
venues.

# Importing the posts into this site

For these reasons, I have spent a significant amount of time "taking out"
my posts from Medium and reformatting them to fit this site.  The result
are Markdown posts that are easier to deal with and are future-proof: the
Markdown format is simple enough and readable enough that one can imagine
the text being perfectly usable and parseable years down the road.

This was an excruciating process and I was lucky to only have 8 posts to
export.  I started by using
[`html2text`](https://pypi.python.org/pypi/html2text) to convert the Medium
export into Markdown files.  Then I had to manually strip out Unicode
characters and fix spacing issues in the text itself caused by their
presence.  Then, the worst part, I had to deal with images and embeds.
And, lastly, I had to update this site to tie things together properly.

I do intend to keep posting to Medium but the process will be the other way
around: *first* write the master copy in a format I control and *then*
import it into Medium for promotion.  Maybe this will prompt me to update
the [Markdown2Social](https://github.com/jmmv/markdown2social/) tool to
support direct publication to Medium.

For your reference, here is the list of posts taken out:

*   [2015-10-23: Compilers in the (BSD) base system]({{< relref "2015-10-23-compilers-in-the-bsd-base-system.md" >}})
*   [2015-09-24: An open letter to online support staff]({{< relref "2015-09-24-open-letter-to-online-support.md" >}})
*   [2015-09-20: "Your English is pretty good!", they said]({{< relref "2015-09-21-your-english-is-pretty-good-they-said.md" >}})
*   [2015-09-07: My coding workflow]({{< relref "2015-09-08-my-coding-workflow.md" >}})
*   [2015-06-19: How to commit a code hack and not perish along the way]({{< relref "2015-06-19-how-to-commit-a-code-hack.md" >}})
*   [2015-06-06: Get a handle on email subscriptions]({{< relref "2015-06-06-get-a-handle-on-email-subscriptions.md" >}})
*   [2015-05-26: Six years at Google]({{< relref "2015-05-26-six-years-at-google.md" >}})
*   [2015-05-24: Hello, Medium!]({{< relref "2015-05-24-hello-medium.md" >}})

# What about The Julipedia?

Unfortunately, the complaints above do not apply to Medium alone.

The data liberation issue applies equally to Blogger, and thus to [The
Julipedia](http://julipedia.meroh.net/).  It is true that Blogger is in a
better position than Medium because one can compose posts directly in HTML
(as I have been doing) so you can actually take out almost-exactly what you
put in.  Unfortunately, Blogger has a tendency to mess up the HTML you type
if you happen to embed verbatim text or use the WYSIWYG editor by mistake.
Therefore, I am also thinking of taking some of the posts out from there
and putting them here... but I will not call The Julipedia dead until that
happens.

To tie things together, I have done a few improvements to this site and
made the blog section a first-class citizen.  In particular, I have added
excerpts to all the posts, improved the [posts index](/blog), and added
commenting support via Disqus.  (What?  I am complaining about Data
liberation above and I still resorted to an external commenting system that
I do not run?  Yes, that's a fair point...  but I'm not ready to run a
dynamic web site yet.)

> [Subscribe via RSS right now](/feed.xml) to not miss a beat.  And if you
> happen to read this, would you provide the very first comments to this
> site via the comment box below?
