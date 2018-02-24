---
title: From Jekyll to Hugo
date: 2018-02-24 06:00:00 -0400
categories:
  - blog
  - writing
---

It is done. This site is now powered by [Hugo](https://gohugo.io) instead of [Jekyll](https://jekyllrb.com). It took me a full week's worth of early mornings to achieve, but the results are great... internally, that is, because as a reader you should notice no changes other than minor style tweaks.

# Performance differences

As of today, this site hosts 711 posts totaling 3.4MB of text. The style sheet is based on [Bootstrap](https://getbootstrap.com) and is built from scratch using SASS.

## Jekyll

In the previous Jekyll build, I had a huge hack in place to generate the chronological archive of all posts. The first attempt at doing this purely within Liquid templates took minutes to render—about 5 if I remember correctly. Because the delay was unbearable, I came up with a helper script to generate the archive and a multi-pass build to fit it in. This brought down build times to about a minute.

A minute for the full build was still too long. I added even more hacks to build a "developer-mode" version of the site in which only the most recent 10 posts would be built, and a "production" version which was only built at deployment time. This was OK for a little bit but started failing miserably the more cross-references I used between posts: suddenly, the 10 posts limit was insufficient, and this ended up growing to the hundreds. In the end, the developer-mode version of the site wasn't that much faster to build.

Fast-forward a little bit and I spent some time profiling Liquid and optimizing my templates. In the end, I got the full site to build in **about 10 seconds on my Mac Pro 2013 with Jekyll**.

Not too bad, I thought, but this non-standard setup always felt clunky, because it was.

## Hugo

The original blind migration of all posts to a skeleton Hugo project resulted in the site building in a few hundred milliseconds. Promising, but I still hadn't implemented any complex templates and those could still make things worse.

But nope. After porting all templates to Hugo, including the slow full archive generation, **the full site builds in 700ms**. That's right: **less than one second**. That's more than 10 times faster than Jekyll and without any hackery involved. Even better: **incremental rebuilds to preview a post edit take about 300ms**.

Hugo fulfills its promise of being fast.

# Disconnected thoughts

Highlights:

* The site you are looking at right now is pretty much the same as it was before. I could not do a 1:1 migration due to Jekyll vs. Hugo differences but nothing of value was lost.

* Page summaries (excerpts) are easier to manage in Hugo, but more limited. Hugo's built-in support to generate page summaries is great when it works, but when it doesn't, you cannot overwrite the summary. Easy enough to workaround in the templates though.

* Have you noticed page reading times? That's a nice tiny feature that I first observed in Medium and never crossed my mind to be doable in a static site. I don't know why. But of course it is, and Hugo has built-in support for it. (A little search now shows that there are plugins for Jekyll too, obviously.)

* I was originally very excited by Hugo's predefined themes. I previewed a bunch that looked cool, but in the end they all felt clunky. Either they didn't work well or my site's contents didn't fully adapt to the theme's expectations. The more I looked, the more I realized that I actually like my current hand-crafted theme: it fits my needs and I understand what's going on under the hood. In the end it was easy to migrate my theme.

* Aliases are cool. The previous version of the site had a bunch of static files to implement redirects for the few cases where I had to move content around and didn't want to break permalinks. Hugo has support for this kind of thing built in by means of page aliases. No more obscure files lying around.

Lowlights:

* Like Go, Hugo is opinionated on how you should do things. I put a lot of effort in respecting all post and feed permalinks to avoid breaking incoming links and subscriptions, but this means I'm not fully embracing a "standard" file layout. Not a big deal though.

* Hugo's documentation is great once you know what you are looking for: i.e. it is a reference manual. However, little time is spent explaining the basics. I'm still uncertain about what sections and menus are for, for example, or how everything really ties together.

* No symlinks support. I previously used a single symlink to deal with a backwards-compatibility feed location, but these are not supported in Hugo. And, [unfortunately, it doesn't look like they'll be](https://discourse.gohugo.io/t/option-to-retain-symlinks-in-static-dir/4688) (remember the "Hugo is opinionated" lowlight above). As a result, I ended up needing a site post-processing step that creates the symlink after a build, which I'm not too happy about.

* Jekyll parses everything through the Liquid templates system, which was very convenient: sometimes mixing templates within a post is great. Hugo doesn't support this. You can use [shortcodes](https://gohugo.io/content-management/shortcodes/) to obtain a similar effect, but they are limited. But I understand: you have to pay some price to achieve blazing-fast performance.

Difficulties:

* Jekyll's and Hugo's Front Matter are not completely compatible. For example, Jekyll tolerates a list of words within `categories` and splits them as you'd expect, but Hugo requires this to be a list. No big deal—`awk` and `sed` to the rescue! Having all posts as text files has been invaluable.

* Hugo generates post IDs that do not match the file names, which could have broken permalinks for many posts. Not sure why. Fortunately, it's possible to tune the name of the generated files via Front Matter.

* Jekyll integrates with SASS; Hugo doesn't. I ended up adding a [Bazel](https://bazel.build/) build to compile the CSS for the site as I did not want to futz with downloading and installing the SASS compiler. Bazel is a big hammer for this but I'd rather integrate the whole site build into it to remove my custom `Makefile`, so this is a step in the right direction.

* RSS feeds are seemingly trivial with Hugo. Hugo can trivially generate feeds using a built-in template, but it's "strict" on where those feeds go. I wanted to respect the previous feed locations so that I didn't lose the few subscribers that I still have (_thank you_ if you are one of them!)... but it's far from easy. I could respect one location via a configuration setting, but for the other one... I had to put a post-build step in my Makefile to create the right feed in the right place. (See item about symlinks above.)

# Has the move reduced posting friction?

As you can imagine, the switch to Hugo has done little to minimize the friction to post that I experience with a static site. I'm still typing this from VSCode with a side-by-side preview window. The workflow is a bit nicer of course, but that's likely because the migration exercise has refreshed my mind on how things work.

[Last week's experimentation]({{< relref "2018-02-19-looking-to-replace-jekyll.md" >}}) mentioned that Forestry might be a nice UI to interact with the blog. Maybe... or maybe not. With the switch to Hugo, things are worse now. The list of posts has lost its chronological order which makes it impossible to find anything. And the preview feature _still_ doesn't work, which I expected to after I dropped the non-standard Jekyll structure. I still gotta file feedback with the developers... but I sense they might actually fix these issues.

We'll see. More work to be done in this area.
