+++
categories = []
date = "2018-02-23T21:05:04+00:00"
draft = true
layout = "post"
title = "From Jekyll to Hugo"

+++
It has happened. This site is now powered by [Hugo](https://gohugo.io) instead of [Jekyll](https://jekyllrb.com). It took me a full week's worth of early mornings to achieve, but the results are great.

# Performance differences

As of today, this site hosts 711 posts totaling 3.4MB of text. The stylesheet is based on [Bootstrap](https://getbootstrap.com) and built from scratch using SASS.

## Jekyll

In the previous Jekyll build, I had a huge hack in place to generate the chronological archive of all posts. The first attempt at doing this purely within Liquid templates took minutes to render, so I came up with a helper script to generate the archive and a multi-pass build to fit it in. This brought down build times to about a minute.

A minute for the full build was still too long, so I had even more hacks to build a "developer-mode" version of the site, in which only the latter 10 posts would be built, and the "production" version of the site, which was only built at publication time. This was OK for a little bit but started failing miserable the more cross-references between posts I added: suddenly, the 10 posts limit was insufficient, and this ended up growing to the hundreds. In the end, the developer-mode version of the site wasn't that much faster to build.

Fast-forward a little bit and I spent some time profiling Liquid and optimizing my templates. In the end, I got the full site to build in **about 15-20 seconds on my Mac Pro 2013 with Jekyll**.

## Hugo

What's like with Hugo? **The full site builds in 1 second**. That's right. **1 SECOND**.

If you had visited recently, you may notice that the site has barely changed — which is great. I had to give up a few things along the way, but they are no big deal, and the difference in performance is  massive.

# Conversion hiccups

* Jekyll's and Hugo's Front Matter are not completely compatible. For example, Jekyll tolerates a list of words within `categories` and splits them as you'd expect, but Hugo requires this to be a list.
* Jekyll used to parse everything through the Liquid templating system, which was very convenient: sometimes mixing templates within a post is great. Hugo doesn't support this. You can use [shortcodes](https://gohugo.io/content-management/shortcodes/) to obtain a similar effect, but they are limited.
* Jekyll integrates with SASS; Hugo doesn't. I ended up integrating a [Bazel](https://bazel.build/) build to compile the CSS for the site as I did not want to futz with downloading and installing the SASS compiler. Bazel is a big hammer for this but I'd rather integrate the whole site build into it than stop using it.
* Aliases are cool. The previous version of the site had a bunch of static files to implement redirects for the few cases where I had to move content around and didn't want to break permalinks. Hugo has support for this kind of thing built in by means of page aliases. No more obscure files lying around.
* RSS feeds are easy with Hugo, but not as flexible. Hugo can trivially generate feeds using a built-in template, but it's quite opinionated on where those feeds go. I wanted to respect the previous feed locations so that I didn't lose the few subscribers that I still have (_thank you_ if you are one of them!)... but it's far from easy. I could respect one location via a configuration setting, but for the other one... I had to put a post-build step in my Makefile to create the right feed in the right place.
* Page summaries (excerpts) are easier to manage in Hugo, but more limited. Hugo's built-in support to generate page summaries is great when it works, but when it doesn't, you cannot overwrite the summary. Easy enough to workaround in the templates though.

Some highlights:

* Having all posts as plain files is great for any kind of refactoring. I had to do multiple passes over all posts to adjust tiny details in their Front Matter... and you can't beat a trivial AWK script run on all of them at once followed by a `git commit`

Some lowlights:

* I was originally very excited by Hugo's predefined themes. I previewed a bunch that looked cool, but in the end they all felt clunky. Either they didn't work well, or the site's contents didn't fully adapt to the theme's expectations. The more I looked, the more I realized that I actually like my current hand-crafted theme quite a bit. It fits my needs, and I mostly understand what's going on under the hood. In the end it was pretty easy to adapt the Liquid templates to build with Hugo.
* No symlinks support. The RSS issue I mentioned above could be trivially solved if Hugo supported symlinks in the static tree, but it doesn't. And, [unfortunately, it doesn't look like that's going to happen](https://discourse.gohugo.io/t/option-to-retain-symlinks-in-static-dir/4688).

# Forestry

As you can imagine, the switch to Hugo has done little to minimize the friction problems that get in the way of posting. It's a bit nicer of course, but probably because this migration exercise has brought back to mind how the site works.

Now, last week's experimentation mentioned that Forestry might be a nice UI to interact with the blog.

Maybe... or maybe not. With the switch to Hugo, things are worse now. The list of posts has lost its chronological order, which makes it impossible to find anything. And worst of all... the preview doesn't work. I imagined it would solve those issues because I got rid of my custom `make`-based build, but apparently something is still off.