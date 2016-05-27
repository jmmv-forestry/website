---
layout: post
title: "How to merge multiple Git repositories into one"
date: 2014-02-15 16:08:00 -0500
categories: featured git kyua
julipedia: 2014/02/how-to-merge-multiple-git-repositories.html
---
Are you looking for a method to merge multiple Git repositories into a
single one? If so, you have reached the right tutorial!

Please bear with me for a second while I provide you with background
information and introduce the subject of our experiments. We'll get to
the actual procedure soon and you will be able to apply it to any
repository of your choice.

------------------------------------------------------------------------

In the [Kyua project](http://code.google.com/p/kyua/), and with the
introduction of the `kyua-atf-compat` component in the Summer of 2012, I
decided to create independent Git repositories for each component. The
rationale was that, because each component would be shipped as a
standalone distfile, they ought to live in their own repositories.

Unfortunately, this approach is turning out to be a bit of an
inconvenience: it is annoying to manage various repositories when the
code of them all is supposed to be used in unison; it is hard to apply
changes that cross component boundaries; and it is "impossible" to reuse
code among the various components (e.g. share autoconf macros) in a
clean manner &mdash; much less attempt to share the version number between
them all.

So what if all components lived in the same repository a la BSD but were
still shipped as individual, fine-grained tarballs for packaging's sake?
Let's investigate.

# The goal

Obviously, the goal is to get two or more Git repositories and merge
them together. It's particularly important to not mangle any existing
commit IDs nor tags so that history is preserved intact.

For the specifics of our example, Kyua has three repositories: one for
`kyua-cli` (which is the default, unqualified repository in Google
Code), one for `kyua-atf-compat` and one for `kyua-testers`. The idea is
to end up with a single repository that contains three top-level
directories, one for each component, and all independent of each other
(at least initially).

# Process outline

The key idea to merge Git repositories is the following:

1.  Select a repository to act as pivot. This is the one into which you
    will merge all others.
2.  Move the contents of the pivot repository into a single
    top-level directory.
3.  Set up a new remote for the secondary repository to be merged.
4.  Fetch the new remote and check it out into a new local branch.
5.  Move the contents of the secondary repository into a single
    top-level directory.
6.  Check out the master branch.
7.  Merge the branch for the secondary repository.
8.  Repeat from 3 for any additional repository to be merged.

# Sounds good? Let's get down to the surgery!

We need to select a pivot. For Kyua, this will be the default Google
Code repository in <https://code.google.com/p/kyua>. Let's start by
checking it out and moving all of its contents into a subdirectory:

    $ git clone https://code.google.com/p/kyua
    $ cd kyua
    $ mkdir kyua-cli
    $ git mv * kyua-cli
    $ git commit -a -m "Move."

We are ready to start tackling the merge of a secondary repository. I
will use <https://code.google.com/p/kyua.testers> in this example.

The first step is to pull in that secondary repository into our pivot:

    $ git remote add origin-testers https://code.google.com/p/kyua.testers
    $ git fetch origin-testers

And now, check it out into a temporary branch and move all of its
contents into a subdirectory:

    $ git branch merge-testers origin-testers/master
    $ mkdir kyua-testers
    $ git mv * kyua-testers
    $ git commit -a -m "Move."

Done? It's the time to merge the two repositories into one!

    $ git checkout master
    $ git merge merge-testers

And clean some stuff up.

    $ git branch -d merge-testers
    $ git remote remove origin-testers

Voil&agrave;. It wasn't that hard, was it? Just repeat the steps above for any
other secondary repository you would like to merge.

# Parting words

Note that this procedure achieves the goal of preserving the history of
all individual repositories, the revision numbers and the tags. In other
words: all previous history is left intact and all commit logs remain
valid after the merge.

Do you know if there is any easier way of doing this? Would it have any
differences in the actual results?

What do you think about doing the merge for Kyua? I see this as a
prerequisite for the migration to GitHub.
