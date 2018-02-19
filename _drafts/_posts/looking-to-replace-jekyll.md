---
title: Looking to replace Jekyll
layout: post
date: 2018-02-19 00:00:00 +0000
categories: []
excerpt: ''
excerpt_separator: ''
---
Back in [May 2015]({% post_url 2015-05-24-hello-medium %}), I was lured to Medium by its simplicity and growing community, which resulted in me posting a bunch of articles there and enjoying every bit of it. But [I didn't feel the content was mine]({% post_url 2016-01-28-medium-experiment-wrapup %}). So a year months later, my experiments to create static "homepage" resulted in me moving from Blogger and Medium to a [Jekyll](https://jekyllrb.com/)-managed site in [May 2016]({% post_url 2016-05-29-homepage-v3 %}).

Almost two years have passed since that migration and I can only count 7 miserable new posts. This ridiculously-low number, unfortunately, doesn't track my willingness to write—but the friction to posting has become so high that I feared composing quick posts.

Last week was pretty active writing-wise at work, which made me realize I missed writing quite a bit... and this made me reevaluate my choices during this long weekend.

Here are some disconnected thoughts on where I am up to. I do not have an answer yet, but maybe you can help? :-)

# What are the problems?

Why did I say above that "the friction to posting is too high"?

* Building the site takes too long. The site used to take over a minute to build. With some profiling and optimization, I got the full build down to under 5 seconds, but that's still slow. Delays are infuriating, especially when working on the final touches of a post.
* Having to deal with a Git client, an editor, files, commits, builds, and publishing takes all the fun out of jotting down thoughts. I am incredibly lazy to post quick articles because of the overhead involved: if I sit down to write, it's only because I know the content is worth it and is "long enough"... but that's not how blogs typically work.
* The chains to a specific computer are annoying. Preparing the workspace to work on the blog takes effort. Installing all necessary tools is not trivial. My Jekyll set up is a bit unusual. All of these mean that my setup for writing is tied to my home computer, which is already configured, but many times I don't want to write from there.

# What am I looking for?

Not a lot.

First, I want to be able to publish again with minimal overhead, anytime, anywhere. This means having a web UI with create new content and to edit existing content. This does not mean having a web UI to edit the whole site, particularly the layouts and stylesheets.

Second, first-class Markdown support. I consider Markdown to be the digital negative of my posts: a simple-enough, future-proof format. I want whatever platform I use to allow me to compose primarily in this format and to preserve the contents verbatim.

# What are the options?

## Blogger

Should I go back to Blogger? It was simple enough when I used it for more than 10 years...

Nope. Logging into my previous Blogger account took my self back at least 5 years: the service has barely changed since the damage introduced by Google+. Coupled with the fact that Blogger has always been a secondary product to Google (and we know how that goes for many things, _cough_ Reader _cough_), using Blogger at this point would be a bad choice.

Plus there is zero Markdown support.

## Wordpress

Wordpress is the always-tempting option. It's a mature product. There is a good managed service behind it. There are clients for the web and for mobile platforms. There are all kinds of imaginable plugins and extensions. The themes are gorgeous. The friction to publish is very low (OK, not as low as Medium's, but still low enough).

I was even excited to see [an option to enable Markdown support for posts](https://en.support.wordpress.com/markdown/)... but in playing with it, I found it lacking. It took me a while to discover how this works given that, after enabling this option, the UI does _not_ change: the composer is still only offered in the WYSIWYG and HTML versions. The trick is that you can actually type Markdown in either of them, and Wordpress will respect the markup.

Good enough? Almost. If you compose in the HTML version and write Markdown there, and as long as you don't switch to the WYSIWYG editor, Wordpress seems to respect your input verbatim. But then try a site export: the exported contents lose the original formatting, which is replaced by some simplified HTML version.

There is one more thing: Wordpress.com has a "new" UI to manage your site, but this is quite incomplete. You can fall back to the legacy (?) wp-admin interface to do anything you need (like enabling Markdown support), but this duality doesn't give me a good vibe.

## Hugo + Forestry

What if there was a fast static site generator with a decent web UI? Would it be too hard to come up with this myself? It certainly doesn't seem that hard to write support for the few things I need.

The good news are that these have been invented already.

First, a bit of searching turned out [Hugo](https://gohugo.io/), which is mind-bogglingly fast static content generator written in Go. It really is. A demo site with all of my post