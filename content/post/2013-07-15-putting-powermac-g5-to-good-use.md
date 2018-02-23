---
title: "Putting a PowerMac G5 to good use"
date: 2013-07-15 12:00:00 -0400
categories:
  - "featured"
  - "mac"
  - "powerpc"
  - "review"
julipedia: 2013/07/putting-powermac-g5-to-good-use.html
slug: putting-powermac-g5-to-good-use
---
A few months ago I bought an old PowerMac G5 off of Craigslist and since
then I have been experimenting with various operating systems and
configurations. Before I tell you more about these, let me briefly
explain why I got such a machine.

[<img src="/images/2013-07-15-Power_Mac_G5_open.jpg"
      alt="Power Mac G5 open case"
      class="float-right"
      width="250px"
      />](http://en.wikipedia.org/wiki/File:Power_Mac_G5_open.jpg)

I had always wanted one of these beasts. They look gorgeous (to me) and,
to convince myself to get it, I thought that I would play with the PPC64
architecture. How? By getting NetBSD to run properly on these machines
while learning enough to iron out the few rough edges that I thought
were left. Unfortunately, that story didn't go well (more below), so I
ended up experimenting with various other operating systems.

In this post, I briefly review my experiences with the various
configurations I have tried and give some recommendations as to what
might work better for you.

This specific PowerMac G5 is a dual PPC 970FX 2Ghz with 6GB of RAM, two
SATA hard drives and an ATI Radeon 9600 XT AGP. The machine is
air-cooled and is louder than I had expected; the noise is high enough
to be bothersome if left running all day long in the living room. That
said, in winter, it serves as a cool-looking space heater (really).

Let's get started with the review.

# Debian GNU/Linux (Wheezy and Jessie)

This is, simply put, the best choice if what you want is an operating
system that "just works" out of the box and that comes with modern
software. Getting Debian installed is as easy as recording an
installation image onto a USB drive or a CD-ROM, booting off either and
following the traditional Debian installation procedure. After the
system is up and running, pretty much all hardware works and the machine
feels quite snappy.

Both Firefox and Midori, which are the two modern web browsers available
for Linux powerpc that I know of, work "OK". They are a bit sluggish,
particularly when the rendering window is larger than about half of the
screen surface, but they may be bearable.

The only problem I have encountered so far is poor support for nVidia
cards. Yes, I mentioned above this machine has a Radeon card, but it
came with an nVidia card when I bought it. There obviously is no
official binary driver for Linux for this platform, and the Nouveau
X.org driver is riddled with big-endian issues that make it unusable. I
could have spent time trying to track the problems down, but instead I
bought a replacement card &mdash; the Radeon that I have now &mdash; off eBay which
made the system work flawlessly. Unfortunately, Gnome 3 still refuses to
work with such a card, but any other graphical environment works fine.
(Not that I care much about Gnome any longer, but I was hoping to be
able to play with it a little bit. So far, I have not been able to do so
on any of the machines I own!) KDE 4 behaves reasonably well, and any
simpler environment just flies.

# Fedora (19)

There are PowerPC builds of Fedora available on the website although I
haven't had any success with them. On the first hand, writing an ISO
image to a USB stick [as the installation procedure
explains](http://docs.fedoraproject.org/en-US/Fedora/19/html/Installation_Guide/Making_USB_Media-UNIX_Linux.html)
results in an unbootable installer... which is expected given that
various configuration files in the image hardcode paths to the CD.
Recording the image to a real CD and booting from it works as intended.

Once in the installer, there is no SMU support so the fans of the
machine will run like crazy during the whole installation procedure. As
far as I have encountered online, this problem should go away once the
system is installed, but I have been unable to confirm this.

The biggest pain is that the installer does not deal well with the boot
process of a Mac. The new Anaconda in Fedora 19, unfortunately, is quite
hard to deal with and the partitioning tools don't work well: it is
really hard to create an Apple\_Bootstrap partition from the UI that
"works", as it involves several hacks (like going to the console and
unmounting a file system half-way through the installation). With some
handholding, I could finally get the system installed but it would just
not boot from the hard disk later on. Eventually I just gave up.

# FreeBSD (9.1 and 10.0-CURRENT)

Much to my surprise, FreeBSD works very well on powerpc64 machines
despite it having been an x86-only operating system for many years.
Writing the memstick image onto a USB and booting from it is easy, the
installer "just works" and the system does so too after booting into it.

Unfortunately, at least on my machine, there seems to be a problem with
the SMU driver that [makes the machine turn off when building
pcre](http://lists.freebsd.org/pipermail/freebsd-ppc/2013-March/006207.html)
(and only pcre so far). I suspect this is a bug in the driver because
the machine is rock solid otherwise with this and other operating
systems.

Regardless of this minor annoyance, I have been able to set up a pretty
decent [development machine with shiny bells and whistles like
ZFS](/2013/07/installing-freebsd-with-zfs-root-on.html).

# Mac OS X (Leopard)

Obviously, the native operating system for the Mac is the one with the
best hardware support for this machine. Keep in mind that the latest
release you can get to run on a PowerPC-based machine is
[Leopard](http://en.wikipedia.org/wiki/Mac_OS_X_Leopard), which is a
6-year old system.

[<img src="/images/2013-07-15-Leopard_Desktop.png"
      alt="Mac OS X Leopard desktop screenshot"
      class="float-left"
      width="250px"
      />](http://en.wikipedia.org/wiki/File:Leopard_Desktop.png)

On the bright side, the system feels snappy because the software hasn't
gotten any bloat for a long time.

On the down side, you are stuck with a stale release on which most
modern third-party software does not work. Keep in mind that most
software nowadays use APIs only available after Leopard, and that the
binaries are no longer built for PowerPC. This is a problem with, for
example, Firefox: you are left to use a really ancient release that is
probably riddled with security issues.

**Edit**: [atomicules@ lets me know on
Twitter](https://twitter.com/atomicules/status/357039067747201025) that
the [TenFourFox](http://www.floodgap.com/software/tenfourfox/) and
[Leopard-webkit](https://code.google.com/p/leopard-webkit/) projects
provide up-to-date browsers for PowerPC-based macs. Neat.

# NetBSD (6.99.x)

This is the sad bit of this post. NetBSD claims to support the G5 in
32-bit mode only, but in reality the macppc port does not work at all
on, at least, my specific PowerMac G5 model. Problems start right from
the bootloader, which is unable to properly load a kernel. Applying some
still-unofficial patches give the bootloader a chance to make some more
progress, but then the kernel fails miserably to do anything useful.
Even with all this fixed, you are still left with a 32-bit based OS
running on this 64-bit capable machine, which means the amount of RAM
you can use is limited, among other things.

# Summary

If you just want to use the machine as it was built and experience some
not-so-old times, go for the original OS X Leopard. If you do that, be
aware that you'll have to cope with outdated software and that such
software is most likely plagued by security holes. Better to not connect
the machine to the Internet.

If you want to make the most of the machine for desktop use, go for
Debian. Note that some other distributions might work as well, but I
have not tried them.

If you want to use the machine as a server or development machine, go
for any of Debian or FreeBSD. Both work equally well in this area.

And, with this, we'll resume the readability series next Thursday.

Image credits: Wikipedia.
