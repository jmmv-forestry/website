---
title:      Six years at Google
date:       2015-05-26 12:00:00 -0400
categories:
  - "essay"
  - "featured"
  - "google"
  - "personal-story"
  - "work"
medium:     six-years-at-google-8b06563fab08
---

> **Mission: Site Reliability Engineer for the Storage Infrastructure at Google**
>
> **D-Day: May 25th, 2009**
>
> **Location: Dublin, Ireland**
>
> **Duration: Unspecified**

Six years have passed. Six years since I dropped out of a Ph.D. program, left home, and took a plane to Dublin, Ireland, to start my work life adventure by joining Google. Two years later, I moved to New York City and I am still here without any specific plans to leave.

More specifically, yesterday was my "Googleversary" so I appropriately tweeted about it:

> [6 years at Google today and counting.](https://twitter.com/jmmv/status/602832671757225984)
>
> 9:44 AM - 25 May 2015

and got a coupe of follow-up questions from @ajm113 (edits mine):

> How would you summarize your experience at Google so far if I may ask at this point? What would you say was the most difficult project at Google if your NDA will let you?

Answering these would take much more than a tweet, so here I go with a Medium post to follow up on [my experimentation with this platform]({{< relref "2015-05-24-hello-medium.md" >}}).

# The internship

My relationship with Google is a long one. It all started in 2005 when I applied for a Summer of Code project ([tmpfs for NetBSD](http://netbsd-soc.sourceforge.net/projects/tmpfs/)) and got accepted. The same thing happened in 2006 ([process management library for Boost](http://www.highscore.de/boost/process/)) and in 2007 ([Automated Testing Framework for NetBSD](http://netbsd-soc.sourceforge.net/projects/atf/)).

By the end of 2007, I got this funny-looking email that my brain-based spam filter threw away only to realize, seconds later, that the subject said something about Google. I recovered the email and read it. There it was: a Google sourcerer expressing interest in what I had to say about C++ and Unix based on [my blog](http://julipedia.meroh.net/).

A couple of discussions with friends to convince myself and a few emails later, I was on my way to applying for an internship---something I had not thought about earlier because internships, as U.S. tech students know them, are not a common thing in Spain: for one, they are not well-paid if at all, and for another, they are not glamorous.

The internship application went well and I was set to start in New York City in July 2008. _OMG_, really: I had never left home, never traveled, never lived alone before. This was a big change and, spoiler alert, the personal experience was much more valuable than the job itself.

<div class="frame">
  <div class="content">
    <iframe width="640" height="360" src="https://www.youtube.com/embed/cdnoqCViqUo" frameborder="0" allowfullscreen></iframe>
  </div>
  <div class="footer">
    <p>A funny movie indeed (though you may disagree), but its portrait of an internship at Google is not accurate.</p>
  </div>
</div>

How did I get the internship position, you ask? I am convinced that _the hands-on experience I gained through contributions to open source_ and, in particular, via all the work I put in porting software---_cough_ [Gnome](http://www.gnome.org/) 2.x _cough_---to NetBSD were crucial in getting me the internship and, later, the full-time position. Not because of the open source work itself, but because of all I learned in the process: porting software across operating systems requires a lot of deep systems knowledge and troubleshooting skills, both of which are key competencies for an SRE.

> Pro-tip: If you want to gain real-world experience as a student before
shooting for a real job, look at the open source world and _get involved_. It doesn't matter if you don't yet know much as long as you embrace your activities as a learning opportunity. Be ready to take (possibly harsh) feedback in a constructive manner and head to [Producing Open Source Software](http://producingoss.com/) by Karl Fogel for a good book on the topic.

The summer of 2008 was was an interesting period. As projects go, I got to implement a visualization tool for world-wide traceroute data on top of Google Maps. The project was visual, which in turn made it fun; I got to develop a significant amount of Java code; and, more importantly, I wrote a bunch of automation scripts to deploy and manage the project. As it turns out, these hands-off scripts were the tipping point to prove me worthy of an entry-level SRE position (or so I was told I think).

# The full-time journey

When I started as an SRE in 2009, I did so in one of the Storage Infrastructure teams: the team supporting the [Google File System (GFS)](http://research.google.com/archive/gfs.html). I found this fitting considering that only three years earlier I had written a file system for NetBSD, but I do not know now if the two events were related. (Note to self: ask my first manager; maybe.)

After GFS, I have been in three other storage SRE teams: the team supporting [Bigtable](http://research.google.com/archive/bigtable.html), the team supporting the successor to GFS, and the team supporting Persistent Disk. All of these teams have been tightly related at times and changed forms over the years, so it's hard for me to really say that these have been four different teams in all.

Location-wise, I have been based in two offices so far---2 years in Dublin, 4 in New York City---and visited seven other offices and two datacenters worldwide if memory serves well. Both the Dublin and New York offices have changed massively during these 6 years and grown from relatively "small" locations to the two big giants that they are today. Much fancier now than they were, I must add.

And interns! I found my internship experience enlightening in many different ways and, for this reason, I especially enjoy mentoring interns nowadays. This is why I had to close the cycle: I hosted my first intern in 2013; two engineering practicum interns in 2014; and, just today, I welcomed my intern for 2015.

# On being an SRE

What is SRE? Ben Treynor, VP of Site Reliability Engineering, and Niall Murphy have an excellent piece on what this position entails:

> [**Site Reliability Engineering**](http://www.site-reliability-engineering.info/2014/04/what-is-site-reliability-engineering.html)
>
> In this interview, Ben Treynor (VP, Site Reliability Engineering) shares his thoughts with Niall Murphy

but, of course, I did not know any of this back in 2009---if only because, at the time, SRE was a pretty new term and the details of the job were not as formalized as they are today.

One thing that was obvious then and is even more obvious now is that I did not know "anything" about what being an SRE meant back in 2009. I'm convinced that I landed into the SRE organization instead of into a pure software engineering position because of my experience with Unix systems as a programmer, not because of any previous expertise with large distributed systems---mind you, I had none. This is not a bad thing actually.

Friends have asked if I received training during these years. Sincerely, I do not think I have ever had any kind of formal training during this period of time, but I am well aware that I have learned _a damn lot_ while doing my job.  For this alone, having been an SRE this far has been very rewarding.

But what kind of job have I been doing? As I tell interview candidates over the phone:

> As an SRE, your job is extremely varied: one week you may be coding
intensively; another week you may be writing a design document to propose a solution to a problem you have spotted; another week you may be tweaking monitoring rules; another week you may be full-time on-call; and another week you may be visiting your remote development team to discuss new ideas and/or to socialize.

> The above are just examples of the kind of activities you may do, but there
are many more. It is expected for you to drive your own work and, to some extent, to "define yourself".

> What's more interesting, though, is that as an SRE you have to care about
"the big picture" instead of just a single component or module of the product you support. This gives you more opportunities to streamline the system and easier chances to interact with other teams---if that's the kind of thing you like doing.

Oftentimes I have thoughts of transferring to a pure development job to have the time to "just code", but then I change my mind when I think I would be losing the variety of tasks described above; it's hard to get bored!

# Projects

It is hard to tell you much about any of the specific projects I have worked on. As you may expect, this is because of confidentiality reasons but not because the projects themselves have been super-secret and cannot be explained, but because explaining the projects requires a ton of context---and that context is what is confidential. That said, let me try to describe something interesting in this area.

Myself, being a software engineer _first_, a systems engineer _second_, and a systems administrator _third_, I have focused on the design and implementation of software solutions to various issues we had in the management of our storage stack. Most of the times, these "software solutions" have been automation systems to manage the software we deploy with the goal to reduce manual operational overhead and to permit the deployment of "higher-level" components.

Nowadays, I am working on [Persistent Disk](https://cloud.google.com/compute/docs/disks/persistent-disks), a component of the [Google Compute Engine](https://cloud.google.com/compute/docs/), and my personal goals are to make this piece as reliable and as easy to manage (operationally) as possible.  The highlight, for me, of working in this team is that Persistent Disk is a user-facing product, which is in contrast to all the previous teams I worked for before. This difference is interesting because our work very visibly can affect the end user experience and, as an on-caller, because we are first-in- line to help fix problems directly perceived by end users.

# The future

Is "being an SRE" what I want to do when I grow up? Probably not. While SRE is great, I find it lacks the kind of visibility I would most enjoy: creating new products and being able to showcase my work to the public. (This is why I enjoy working on open source so much, by the way.) That said, it's very hard to articulate this for me because I'm still struggling to organize my thoughts in this area.

Is Google the company I want to retire from? Probably not either. Google is an awesome company to work for but: first, it's the only place I've worked in so far; and, second, the positions I'd be _really_ interested to work for all seem to be based on the U.S. West Coast, a place that makes little sense for me for personal reasons at this time. (Unfortunately, the same applies to many other tech companies.)

But, until the time comes to make a decision, this is a pretty damn good place to be in!
