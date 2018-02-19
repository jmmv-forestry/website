---
title: Looking to replace Jekyll
layout: post
date: 2018-02-19 00:00:00 +0000
categories: []
excerpt: ''
excerpt_separator: ''
---
Back in [May 2015]({% post_url 2015-05-24-hello-medium %}), I was lured to Medium by its simplicity and growing community, which resulted in me posting a total of 8 articles there. Wow, not many. A few months later, my [experiments to create static "homepage"]({% post_url 2015-10-22-new-homepage %}) resulted in me moving from Blogger and Medium to a [Jekyll](https://jekyllrb.com/)-managed site in [May 2016]({% post_url 2016-05-29-homepage-v3 %}).

Almost two years have passed and I can only count 7 miserable new posts since. The thing is that this ridiculously-low number doesn't track my willingness to write. Unfortunately, the friction to posting has become too high with the move to Jekyll and the current non-standard setup I got. In particular, I have these issues:

* Building the site takes too long, which is infuriating when doing the final touches in a post. The site used to take over a minute to build. With some profiling and optimization, I got the full build down under 5 seconds, but that's still slow and annoying.
* Having to deal with a Git client, an editor, files, commits, builds, and publishing takes all the fun out of jotting down thoughts. I am incredibly lazy to post quick thoughts because of the overhead involved: if I sit to write, it's only to write a long-enough document... but that's not how blogs typically work.

And last week was pretty active writing-wise at work, which made me reevaluate my choices about my blog this long weekend. I've investigated a bunch but have no answer yet.

Markdown support, which is a deal-breaker for me because I want to keep my originals in a simple and future-proof format,

# Blogger

Should I go back to Blogger? It was simple enough.

Nope. Logging into my previous Blogger account brings me back 5 years or more: the service has barely changed since the damage introduced by Google+. Coupled with the fact that Blogger has always been a secondary product to Google (and we know how that goes for many things, _cough_Reader_cough_), going back would be a bad choice.

# Wordpress

Wordpress is the always-tempting option. It's a mature product. There is a good managed service behind it. There are clients for the web and for mobile platforms. There are all kinds of imaginable plugins and extensions. The themes are gorgeous. The friction to publish is very low—OK, not as low as Medium's, but still low enough.

I was even excited to see an option to enable Markdown support for posts... but in playing with it, I found it lacking. It took me a while to discover how this works given that, after enabling this option, the UI does _not_ change: the composer is still only offered in the WYSIWYG and HTML versions. The trick is that you can actually type Markdown in either of them, and Wordpress will respect the markup.

Good enough? Almost. If you compose in the HTML version and write Markdown there, and as long as you don't switch to the WYSIWYG editor, Wordpress seems to respect your input verbatim. But then try a site export: the exported contents lose the original formatting, which is replaced by some simplified HTML version.

# Hugo

[https://gohugo.io/](https://gohugo.io/ "https://gohugo.io/")

# Forestry