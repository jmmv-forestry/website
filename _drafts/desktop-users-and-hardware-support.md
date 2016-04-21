---
layout:     post
title:      On the success of an OS
date:       2016-04-20 09:00:00
categories: essay
excerpt_separator: <!--end-of-excerpt-->
---

As the summery breeze blew through my apartment this morning, my mind was transported to the day I started tinkering with NetBSD. Those were the days of 1.5 and I vividly remember holding the purple-colored CD I had burned and the yellow-on-black installer. Of course, this was not my first exposure to Unix systems nor other alternative OSes: that history started with OS/2 Warp 3 on 1994 and was then followed by several years of Linux usage.

But I digress. For some reason---the mind works in mysterious ways---this event made me think of a couple of topics I've been meaning to blog about for a while: first, the ever-increasing importance of good hardware support; and, second, the need for your OS to support desktop users first-hand. These two topics are intertwined and, I believe, are necessary (but not sufficient) for releasing a successful OS.

<!--end-of-excerpt-->

# Hardware support

Back when I started toying with alternative operating systems to the omnipresent Windows, getting all hardware to work was a tricky problem but, with some effort, it could be done. When I switched to the BSDs by the year 2000, I was pleased to see that pretty much everything worked except for the remote control of my TV card---something I could live without.

During the next few years, the situation remained similar until, at one point, I extended my list of "exceptions" to include the lack of 3D support. I did not care about this either because I did not play games on neither Linux nor the BSDs---mind you, there weren't any. But then something happened: larger monitors with higher resolutions and composite window managers. In particular, I upgraded to 20" monitor and later to a 24" monitor, which turned my Gnome 2.x desktop on NetBSD into an unusable mess. Suddenly, even if I didn't care about the 3D bits, the lack of accelerated graphics support became a serious issue.

Things have gone downhill from there. We have moved to a mobile world where laptops dominate, and laptops come with all kinds of funky hardware that is not well-supported. Consider the constant problems with WiFi interfaces, suspend/resume, power/thermal management, graphics cards, trackpads with multi-finger/scrolling support, sound cards, multimedia keys... Somehow, the number of devices that need to be supported has increased and the drivers haven't kept up. It doesn't help that the hardware has become more stupid by shifting responsibilities to the software drivers, which makes them harder to reverse-engineer.

As a result, it feels like getting full hardware support for any given computer is harder than ever. But... no matter how hard it is to have full hardware support, having such support is an assumed minimum: justifying the full lack of support by saying things like---as I did---"everything works except for this button or these keys" is just not acceptable. Either the whole computer works, or it doesn't.

I know this is a really hard problem to address. One possibility would be to pick fewer battles and focus on supporting a bunch of specific computer models. At the very least, this would help the developers focus on shipping one fully-working product instead of a half-working product that more-or-less works in many situations.

It doesn't help that VMs are now ubiquitous and a large chunk of developers, myself included, now only run their OSes within a VM to---partly for simplicity, and partly to not have to deal with hardware support issues. Unfortunately, this is a self-fulfilling prophecy: if the developers don't use the software they build on native hardware, they are oblivious of the underlying problems. What's more is that, because you are running the OS in a VM, you have an easy escape hatch to the host OS to do whatever you have to do that is not specific to OS development. This is a big problem because the developers don't get to use their own software on a daily basis... which brings me to the next point.

# Desktop support

For a long time, I have believed that having full-featured desktop support in an OS is critical. Full desktop support is a prerequisite for reaching a wider audience outside of the few masochists that deal with problems just because, which in turn is a prerequisite for growing the developer pool.

Think about Ubuntu. Ubuntu started as a great distribution which focused, exclusively, on the desktop. Because Ubuntu got a functional system up and running without fuss, it spread quickly, and it did so outside of the hardcore geek circle: non-tech-y but curious individuals were trying Ubuntu just because. It wasn't until later that Ubuntu Server appeared, and at that time it was seen as a joke: "who'd want Ubuntu on a server?!". But look at the ecosystem today: Ubuntu Server is available out of the box on the major cloud providers; people choose Ubuntu server as their OS for production work; there are plenty of Ubuntu derivatives that have become popular... and even Microsoft has chosen Ubuntu to base their Linux support on.

My belief is that because Ubuntu just worked on the desktop, it allowed people to use Linux on a daily basis. Among this group of people were developers, and among these developers were some that ended up contributing to the project. The net effect is a larger worker pool that contributes their free time to advance their favorite operating system to any areas they choose, and has resulted in a Linux distribution that is favored by many.

Focusing your OS on the server is a great way to stay focused... but is also a nice way to alienate your potential developers. It's true that you'll only attract the "hardcore" developers that: one, already know your product; and two, want to make it advance, but you will not attract any of the developers that can help really advance your user-base and, thus, attract other skilled developers, without marketing efforts.

It happened to me, and I've witnessed this happen on many others: once I abandoned Linux and the BSDs as my desktop OS of choice, I stopped encountering problems; and as I did not encounter problems, I stopped contributing upstream. The only thing I do these days is run these OSes in VMs to develop my own software---which you'd say is better for me because it lets me focus my efforts on my thing, but is worse for the OS project *itself* because it doesn't receive any of my time any longer.

Note that none of this works the other way though: OS X is a magnificent desktop OS, but it just doesn't work on the server---especially when you consider that even Apple killed the Xserve line and the Mac OS X Server edition. (Yes, yes, I know you *can* run OS X on a server, but that's not something you'd want to deal with.)

What do you think?
