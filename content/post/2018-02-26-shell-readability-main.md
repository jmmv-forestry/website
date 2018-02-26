---
title: "Shell readability: main"
date: 2018-02-26 05:15:00 -0400
categories:
  - readability
  - shell
---

Our team develops [Bazel](http://bazel.build), a Java-based tool. We do have, however, a significant amount of shell scripting. The percentage is small at only 3.6% of our codebase... but given the size of our project, that's about 130,000 lines—a lot, really.

Pretty much nobody likes writing these integration tests in shell. Leaving aside that our infrastructure is clunky, the real problem is that the team at large is not familiar with writing shell per se. Few people are these days actually.

In order to fix this, I have two plans. The long-term vision is to switch to a different language; I already have a design doc to cover this and hope to share the key concepts here soon. But even if we reach agreement and we do that, it will take us months until we are in the "steady state" and can effectively abandon shell. Ergo I'll try to teach everyone some sane shell scripting tips and will start by giving an informal presentation next week.

The take-away from the presentation is simple:

> If you want your scripts to be readable...
> **treat the shell as a real programming language**.

You can write unmaintainable shell scripts that grow to thousands of lines, sure, but *you can also write palatable shell that will stand the test of time*. **This requires a change in attitude:** it means not accepting whatever goes in shell just because it's shell. It means realizing that, as any other language, it takes time to learn the common idioms and accepting that you need to learn them. It means trying to apply common engineering principles to the shell.

My first tip to achieve this is simple and yields the title of this post: **start your shell scripts by defining a `main` function**. You can use a template like this:

```sh
#! /bin/sh

readonly progname="${0##*/}"

main() {
    ... parse flags ...
    ... parse arguments ...

    ... actual stuff ...
}

main "${@}"
```

This simple trick may change your approach to writing scripts. It does for me: the script becomes a program and thus deserves a more principled implementation process. As a result, you may end up:

- Avoiding global variables. Constants are fine, of course.
- Handling flags and arguments first, away from program logic.
- Adding extra helper functions to contain your logic instead of shoveling everything at the top level of the script.

What do you think?

Before leaving, this may be the best time to pitch [shtk](https://github.com/jmmv/shtk/), my library of reusable shell scripting components.
