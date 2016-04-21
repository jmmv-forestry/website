---
layout:      post
title:       Understanding Git
date:        2016-04-15 13:00:00
categories:  git software
---

Whether you like it or not, Git has become the de-facto Version Control System (VCS). As a result, it is better for you overall to be proficient at it than to not be, which is easier said than done: the Git command-line interface (CLI) is hard to grasp and the Git workflows are sufficiently different from those in other VCSs to look alien.

If I had to guess about Git's popularity, I guess two reasons: the first is because of its author and the use in the Linux kernel; and the second is because of GitHub, which is in turn the de-facto hosting platform for open source projects nowadays. We can classify the developers that flocked to Git in two camps: those that have never used a VCS before, for which Git is hard to grasp; and those that have moved to Git from other VCSs such as Subversion, for which Git seems stupid.

Speaking of stupid, Git's own manual page describes Git as *"the stupid content tracker"*---and it really is. Git's object model is remarkably simple: if you can grasp the fundamentals of how Git manages files---and trust me, you can---then the command-line operations will be demystified.

My goal is for you to never again reach the situation where you throw away your working copy and "start over" because you don't know what you have done. You'll also be able to do pretty fancy things to your trees (like, e.g. [merging various repositories into one while preserving history](http://julipedia.meroh.net/2014/02/how-to-merge-multiple-git-repositories.html)).

Think of this post as a crash course to Git's fundamentals and a cookbook for common scenarios. **I will intentionally omit details and provide imperfect explanations**: grasping the concepts is much more important than being 100% correct on the internals. For a detailed and correct (but much longer!) explanation on how Git works, please refer to the [Git Community Book](http://schacon.github.io/gitbook/) and the Git manual pages.

I thought about splitting this article in multiple posts, but then decided to keep everything together for further reference. The next post will also be Git-related, but it'll focus on detailing my personal workflow. Therefore, here is the table of contents to guide you through this piece:

<div id="toc" data-toc data-toc-max="2"></div>

# The object model

Simply put, Git stores objects. Objects are identified by their digest (or hash, SHA1), have a type, a size, and arbitrary content. There are three key object types:

*   **blob**: Stores file data. Consider the following two sample blobs:

        blob: B1
            This is a file!
        
        blob: B2
            This is another file!

*   **tree**: Acts as a file system. The tree contains a mapping of file names to blob identifiers for regular files or other trees for subdirectories. Consider the following two sample trees, referencing the previous blobs:

        tree: T1
            first_file -> B1
            second_file -> B2

        tree: T2
            first_file -> B1
            first_file_copy -> B1
            renamed_second_file -> B2

*   **commit**: Represents a tree at a specific point in time. It does so by attaching metadata to a tree object. Consider the following two sample commits, chained together, and referencing the previous trees:

        commit: C1
            tree:    T1
            author:  Some Person <some.person@example.com>
            date:    Thu Apr 14 11:00:00 EDT 2016
            message: Initial commit!
            
        commit: C2
            tree:    T2
            parent:  T1
            author:  Some Person <some.person@example.com>
            date:    Thu Apr 14 11:05:00 EDT 2016
            message: Duplicate a file

(There also is a **tag** object type that I won't cover.)

NOTE: Of special importance is to notice the **parent** attribute within a commit object, which serves to link all commits. This is the foundation of the revision history mechanism and, because a commit can have more than one parent, the revision history is a [Directed Acyclic Graph (DAG)](https://en.wikipedia.org/wiki/Directed_acyclic_graph).

In practical terms: whenever you commit a change to Git, you are asking Git to create a new tree object. To create the tree object, Git stores all files in the commit as blog objects, then uses their digests to construct the tree. To create the commit object, Git uses the tree just created and the reference to the parent commit (which comes from the current working copy).

## Digests (or hashes)

Pay close attention to the object types: a commit references a tree, and a tree references a bunch of blobs. Therefore, it is extremely important to realize that:

*   the digest of a commit depends on its metadata plus the digest of the referenced tree, and that
*   the digest of a tree depends on the digest of all the blobs it references.

The reason this is important is to later understand rebases and forced pushes.

# Directories and the index

The **working directory** is a checkout of a *single* tree object onto the real file system. The working directory is what you get when you run `git clone` and usually represents the contents of the top of a branch.

The **Git directory** is the directory containing the "Git database", aka the object pool and bookkeeping information. By default, this is the `.git` subdirectory in any Git checkout. The Git directory contains objects for all revisions, not just the one that is checked out in the working copy.

The fact that both the working directory and the Git directory are conflated in a single location in the file system can be confusing at first, especially when compared to other distributed VCSs that store their database aside. But here is the key point:

NOTE: As long as you do not manually poke into the `.git` directory (why would you?), you can *always* restore the working copy to a "clean state" using Git commands. There is no need to destroy the whole directory and re-clone it. Really.

Lastly, there is the **index**. The index acts as a staging area for changes to the working directory that will be committed into Git. Hm, what? Yes, this is confusing. The `git add` command records a change in the index: it does not *only* add a new file to Git, as you would expect based on other VCSs; it also serves to register changes to existing files into the index. The `git commit` command onlys check in the changes previously added to the index, either by `git add` or by other file-level manipulation operations such as `git mv` or `git rm`.

# Branches

**A branch is a name for a commit** that gets updated automatically on specific events. Really, there is *nothing else*. Check it out for yourself:

```sh
$ git branch
  example
  fixes
* master

$ ls .git/refs/heads
example  fixes  master

$ cat .git/refs/heads/master
3e5d0e55293ee53056c38a3b6717a6a7a846faac
```

This is super important, so let's repeat it:

IMPORTANT: A branch is a name for a commit. There is no other magic.

From the above, you can derive that you are *always* working in a branch---i.e. there is nothing special about the master (or trunk, or head) tree and "branches" (other than an implicit link with the remote site). Do not treat branches as something foreign or special as you would do in other VCSs, because they aren't.

## Branches are local

Branch names are *a local construct*: they only exist on your Git directory unless you decide to push them to a remote repository explicitly. You can create and delete local branches at will, and because they are local, their names need not be universally unique (not even across developers in the same project!).

Also, even if you push them to a remote repository, you are not committing to maintaining them at all: they have no special meaning on the remote side either, so they can be renamed and wiped at will. (Contrast this to Monotone, for example, where branch names had globally-unique names and were persistent. Local, cheap branches provide a very different approach to development.)

## Remotes and remote branches

Git also knows of "remotes", which are the addresses of the external repositories you work with and the branches they contain. A remote is identified by a name---`origin` being the default one---and branches within it are referenced by names of the form `origin/master`.

There really is nothing special about remotes either. You can check it yourself:

```sh
# List the remotes known by Git in the current working directory.
$ git remote -v
origin	https://github.com/jmmv/jmmv.github.io.git (fetch)
origin	https://github.com/jmmv/jmmv.github.io.git (push)

# Now let's compare those to the contents in the Git directory.
$ ls .git/refs/remotes
origin

# If we peek inside the only remote, we see two branches.
$ ls .git/refs/remotes/origin
HEAD  master

# If we peek inside the HEAD contents, we just see a "link" to master.
$ cat .git/refs/remotes/origin/HEAD
ref: refs/remotes/origin/master

# And, finally, master (referenced as origin/master) is just a pointer
# to a commit -- exactly like with local branches.
$ cat .git/refs/remotes/origin/master
b9058b6ebe522cd739de27a2c7cc33923da9ccf7
```

NOTE: It is important to understand that branches are always local *unless* you prefix them with a remote name. Additionally, wherever you can use a branch name, you can also probably use a remote branch name.

# Push and pull

**Push** is the operation that pushes objects to a remote repository and updates remote branch or tag pointers to match the new objects.

What's interesting---and thus, confusing---is that pull is *not* exactly the opposite of push. **Pull** is simply a wrapper over the "fetch plus merge" sequence of commands:

*   **fetch** is the operation that actually retrieves objects from a remote repository into the Git directory, and
*   **merge** is the operation that updates the current branch pointer and the working directory accordingly.

## Pulling into an unclean working directory

A common pitfall that users encounter is when pull complains about conflicts. If you pull changes that would modify any file you have locally modified but not committed yet, Git will stop the merge part of the pull operation. Note that the remote objects have *already* been fetched into your repository; it's just that Git was unable to update your working copy to reflect them.

To resolve this situation, all you need to do is put your changes aside. You can do so either by committing them or by stashing them. If you commit your changes, you will create a new revision, which will cause the top of your branch to differ from the remote.

# Merges

## Fast-forward merges

Now that you understand that a branch is simply a pointer to a commit, you can demystify what "fast-forwarded" means when you do a `git pull` or a `git merge`:

```sh
$ git pull
remote: Counting objects: 38, done.
remote: Total 38 (delta 32), reused 32 (delta 32), pack-reused 6
Unpacking objects: 100% (38/38), done.
From https://github.com/jmmv/kyua
   3e5d0e5..1929dcc  master     -> origin/master
Updating 9fad478..1929dcc
Fast-forward
 NEWS.md                         |  6 +++-
 README.md                       |  4 +--
 ... more entries omitted ...
```

Fast-forward means that the branch pointer could be moved along the commit history without introducing new commits, and so this happened. Consider the following history tree, which depicts a `master` branch whose head is commit `C` and we have a `fix-bug-1234` branch which contains two additional commits `D` and `E` to apparently fix bug number 1234.

```
      master: A ---> B ---> C
                             \
fix-bug-1234:                 ---> D ---> E
```

Now suppose we want to merge `fix-bug-1234` back into `master`. We have two strategies: the easy one is to fast-forward `master` to commit `E` (remember, we are just updating a pointer!). Doing so brings the two branches in sync:

```
      master: A ---> B ---> C ---> D ---> E
                                          |
fix-bug-1234:                             E
```

However, the drawback of this strategy is that there is no hint in the history that the merge happened. As we shall see, it's often interesting to keep the merge history so that related sets of commits are grouped. For example, because commits `D` and `E` were used to fix a bug, it is interesting to record that fact in the history.

## Explicit merges

We can tell Git to explicitly introduce a merge point even when a fast-forward would suffice using `git merge --no-ff`. Doing so to merge `fix-bug-1234` into `master` would result in a history graph like:

```
      master: A ---> B ---> C -----------------> F
                             \             /
fix-bug-1234:                 ---> D ---> E
```

Commit `F` in this example is *empty*: the tree object pointed at by `F` is the same tree object as the one in `E`. The only interesting information in `F`, thus, is the other metadata: who the ancestors of the commit are, who did the merge, the log message explaining what the merge is, etc.

More interestingly, you can also run `git merge --no-ff --no-commit` which prepares the commit `F` in your working directory but does not actually commit it. This lets you edit the contents of the tree so you can tie things together at merge time. We'll see more on this on the next post.

## Forced pushes

By default, Git will only let you push to a remote branch if the remote branch can be fast-forwarded to the head you are pushing.

Forcing a push means that the remote branch pointer will be **reset** to your local head. All good? No:

WARNING: **Do not force-push to remote branches used by others.** In particular, do not force-push to `master`.

Force-pushing means that anyone else who had previously checked out the branch (or you yourself on another computer) won't be able to reconcile their local contents with the new contents on the remote site. This is because Git won't have a way to traverse the history graph to find a common ancestor---or, if it finds it, the common ancestor can be so old that any automatic merge attempts by Git will fail.

There *are* valid uses for forced pushes, as we shall see in the next post, but refrain from ever using `git push --force` unless you know very well what you are doing. Otherwise, you *will* inflict pain on others.

## Rebases

Rebasing is a very common operation in Git. A rebase basically means: take all commits that only exist in the current branch and "move" them to appear in sequence after another commit.

Let's see this graphically. Consider we have the previous revision history but `master` has received some additional commits after `fix-bug-1234` was created:

```
      master: A ---> B ---> C ---> F ---> G ---> H
                             \
fix-bug-1234:                 ---> D ---> E
```

Now we want to merge `fix-bug-1234` onto `master`. A typical (non-fast forward) merge operation would result in a graph like this:

```
# Merge fix-bug-1234 onto master with conflict resolution on I.

      master: A ---> B ---> C ---> F ---> G ---> H ---> I
                             \                         /
fix-bug-1234:                 ---> D ---> E -----------
```

where `I` potentially has many content changes in it to resolve merge conflicts between `H` and `E`.

With `rebase`, we can mitigate this "problem" by addressing the merge conflicts first: we move the commits forward so that the conflicts arise; we fix the conflicts in the branch-specific revisions, and then we merge them cleanly onto master without any conflict resolution changes required at the merge point. In other words, if we rebase, we get the following revision graph:

```
# Rebase fix-bug-1234 onto master with conflict resolution on D and E.

      master: A ---> B ---> C ---> F ---> G ---> H
                                                  \
fix-bug-1234:                                      ---> d ---> e
```

Note that I have renamed `D` to `d` and `E` to `e` to indicate they are not exactly the same revisions. Even if there were no conflicts, the ancestor of `D` had to be changed from `C` to `H` and therefore the digest of `D` changed as well. Thus:

IMPORTANT: The commit identifier of a commit changes once it has been rebased. This is because the rebase operation changes one or more properties of the original commit.

But rebase is more powerful than that. With an interactive rebase, you can edit the history of a branch at will: you can "squash" multiple commits into one; you can tweak log commits; you can drop existing commits; and you can reorder commits. All these operations are extremely handy to clean up a local branch that has not yet been merged into `master` before actually merging it. `git rebase -i` is your friend.

# Undo!

So you messed up your local working directory. Here are the solutions.

To revert a change recorded in the index, use the `git reset` command. Clearing the index is mostly harmless: any changes to local files will just go back to the non-staged state.

```sh
# Clear the full index.
git reset

# Clear a single file (e.g. to undo a "git add").
git reset <path>
```

To clear all changes to your working directory, use `git reset --hard`. This command is destructive: any non-committed changes will vanish (but any non-added files will remain).

```sh
# Drop all local modifications to the working directory.
git reset --hard
```

Conceptually, what the previous command is doing is checking out again the head revision on top of any existing files (thus undoing changes). You can give an explicit revision identifier to use a different revision *and* to update the branch pointer to that revision. With this trick you can discard a commit you just made in case it was wrong:

```sh
# Discard last commit.
git reset --hard HEAD^1
```

WARNING: *Do not do this after a `git push`.* Once a commit has been pushed out, it is immutable.

# Garbage collection

I've heard a couple of smart individuals disregarding Git as garbage because of two reasons: first, because it needs to perform garbage collection, which kinda implies that you have lost commits; and second, because there is the option of force-pushing to a remote repository, which means that commits are lost. Both of these concerns are just invalid.

Garbage collection happens, primarily, because of rebasing. Every time you rebase changes, you are generating new blobs, new trees, and new commits. The old objects you are replacing can become orphaned because no reference points at them---and this is perfectly normal because that's what a rebase is intended to do.

Forced pushes are the exception, not the norm. One should never use a forced push on a branch that has been publicly published because that prevents users of that branch from syncing. Forced pushes are rejected by default by any well-configured server but are allowed should you need them. In particular, I find them very useful to work on personal development branches on which I want to trigger Travis tests.
