---
title: Looking to replace Jekyll
date: 2018-02-19 00:00:00 +0000
categories:
  - blog
  - writing
excerpt_separator: <!--end-of-excerpt-->
slug: looking-to-replace-jekyll
---

Back in [May 2015]({{< relref "2015-05-24-hello-medium.md" >}}), I was lured to Medium by its simplicity and growing community, which resulted in me posting a bunch of articles there and enjoying every moment of it. But, eventually, I noticed that [I was losing control of my content]({{< relref "2016-01-28-medium-experiment-wrapup.md" >}}). So [a year later]({{< relref "2016-05-29-homepage-v3.md" >}}), my experiments to create static homepage resulted in me moving from Blogger and Medium to a [Jekyll](https://jekyllrb.com/)-managed site.

Almost two years have passed since that migration and I can only count 7 miserable new posts. This ridiculously-low number, unfortunately, doesn't track my willingness to write—but **the friction to posting has become so high** that I fear composing new essays.

<!--end-of-excerpt-->

Albeit late, this hit me last week. I wrote a couple of long-form articles for work and the process made me realize I miss updating my blog more frequently. And thanks to this long weekend, I've been reevaluating my choices and trying new things.

Here are some disconnected thoughts on where I am up to. I do not have a final answer yet on what to do; maybe you can help?

# What are the problems?

Why did I say above that "the friction to posting is too high"?

* Building the site takes too long. The site used to take over a minute to build. With some profiling and optimization, I got the full build down to under 10 seconds, but that's still slow. Delays are infuriating, especially when working on the final touches of a post or during site redesigns.

* The workflow is too heavy. Having to deal with a Git client, an editor (VSCode), files, commits, build scripts, and the actual deployment takes all the fun out of jotting down thoughts quickly. I am incredibly lazy to post articles because of the overhead involved: if I sit down to write, it's only because I know the content is worth to work on, but the results are very infrequent and very long posts. That's not how blogs typically work.

* The environment is non-inviting. Kinda related to the above, getting the environment set up takes effort and I never know where I left things the next time I want to pick writing up. Installing all necessary tools is not trivial. My Jekyll set up is a bit unusual due to some preprocessing involved in generating the archives index. Many times I want to start a draft and preview it, but I'm not in the right computer or some tool has stopped working.

# What am I looking for?

Not a lot I'd like to think.

First, I want to be able to **publish again with minimal overhead, anytime, anywhere**. This means having a web UI with which to create new content and to edit existing content. This means having a UI with which to manage drafts. This does _not_ imply having a UI to edit the whole site, particularly the layouts and stylesheets: changing these is infrequent, so I can go down into the console when truly necessary.

Second, **first-class Markdown support**. I consider Markdown to be the digital negative of my posts: a simple-enough, future-proof format. I want whatever platform I use to allow me to compose primarily in this format and to preserve the contents verbatim.

And third, **data liberation**. I want to own my data. This means being able to access my posts in a format that's "future-proof". Many blogging platforms offer export functionality, but the output is often mangled HTML that can't really be imported anywhere else because the formatting is built into the text and the logical layout is missing.

# What are the options?

Here is what I've been considering and testing.

## Blogger

Should I go back to Blogger? It was simple enough when I used it for more than 10 years... and it's still the same thing it was.

Logging into my previous Blogger account brought me back in time 5 years or more: the service has barely changed since the damage introduced by Google+. Coupled with the fact that Blogger has always been a secondary product to Google (and we know how that goes for many things, _cough_ Reader _cough_), using Blogger at this point would be a bad choice.

Plus there is zero Markdown support and Blogger often messes up hand-crafted HTML.

## Wordpress

Wordpress is the always-tempting option. It's a mature product. There is an apparently-good managed service behind it—there is no way I'm running this insecure piece of software myself. There are clients for the web and for mobile platforms. There are all kinds of imaginable plugins and extensions. The themes are gorgeous. The friction to publish is very low (OK, not as low as Medium's but still low enough).

I was even excited to see [an option to enable Markdown support for posts](https://en.support.wordpress.com/markdown/)... but in playing with it, I found it lacking. It took me a while to discover how this works given that, after enabling this option, the UI does _not_ change: the composer is still only offered in its WYSIWYG and HTML versions. The trick is that you can actually type Markdown in either of them, and Wordpress will respect the markup.

Good enough? Almost. If you compose in the HTML version and write Markdown there, as long as you don't switch to the WYSIWYG editor, Wordpress seems to respect your input verbatim. But then try a site export: the exported contents lose the original formatting which is replaced by some simplified HTML version. Not sufficient for my desires.

There is one more thing: Wordpress has a "new" UI to manage the site, but this it is incomplete. It's possible to fall back to the legacy (?) `wp-admin` interface to do anything you need—like enabling something as basic as Markdown support (!)—but this duality doesn't give me a good vibe.

## Hugo

What if there was a fast static site generator with a decent web UI? Would it be too hard to come up with one myself? It certainly doesn't seem that hard given that there are plenty of libraries to parse and render Markdown, Front Matter, YAML, etc. (haha, but it wouldn't be easy either).

The good news is that this has already been invented.

Enter [Hugo](https://gohugo.io/): a mind-bogglingly fast static content generator written in Go. It really is. A demo site with all of my posts in it takes less than a second to rebuild. Even posts reload live in the browser for immediate previews: no need to hunt down an editor that offers this on its own.

The tool looks mature all around. The command line feels polished, the documentation is abundant, and there are lively discussions on the bug tracker denoting it's not dead. The project layout feels nicer than Jekyll's (if only because I despise those underscore prefixes in all of my originals).

On the other hand, I tried a bunch of the themes for Hugo. At first I was "wow, this looks amazing" but I kept hitting shortcomings in most of the themes I liked. I can probably migrate my current hand-crafted theme, but I just realized I rely on Jekyll's SASS integration which Hugo doesn't seem to offer.

## Web UIs for Jekyll/Hugo

As for a web UI to manage a static site, there are a bunch of them that seem decent.

The one that caught my eye the most so far, maybe because of its visuals and free offering, is [Forestry](http://forestry.io/). This connects to a GitHub repository and lets you manage a Jekyll or Hugo site from the web. There are many rough edges here, but the basics of post management seem to exist and the WYSIWYG editor is pretty decent. You don't get to edit the site's visuals from the UI, but as mentioned earlier, this is not that important for my use cases.

The other one that seems quite promising is [Netlify](http://netlify.com/) but I haven't had a chance to play with this one yet.

# Where am I at?

Well. I'm typing this right now from Forestry. I ended up connecting this tool to my already-existing Jekyll site to give it a real shot. Despite of its shortcomings, Forestry seems to mitigate some of the friction problems I am having. Typing this post has been a nicer experience than usual.

The problem is I'm still not happy with Jekyll after having discovered Hugo. I played significantly with Hugo over the last two days and tried to migrate the full site. Even though I haven't been able to complete a migration, I like the experience so far: it is super-fast; the workspace contents feel better thought-out; and it's written in a language that I know and enjoy, which means I can dive into its internals if I need to.

But Hugo is still a static content generator. The friction problems with site design and posting still exist. It's not as a well-rounded solution as Wordpress would be out of the box... but it does fulfill my wishes of keeping Markdown originals and having direct access to the underlying data.

So I don't know. I'll keep playing with Hugo. I think Hugo+Forestry can be a great combination if I manage to set up the site the way I like. And if I can do so while respecting its current looks and links, why not? At least it won't be any worse than what I have today...
