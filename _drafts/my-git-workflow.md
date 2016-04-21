---
layout:      post
title:       My Git Workflow
categories:  development essay
excerpt_separator: <!--end-of-excerpt-->
---

On [My coding workflow](TODO), I presented the way I work on the command line to handle various different console-based projects. It's now the time to dive into the specifics of how I interact with a tool: Git.

This article is based on the [contributing guidelines to the Kyua project](https://github.com/jmmv/kyua/blob/master/CONTRIBUTING.md).

<!--end-of-excerpt-->

# Centralized workflow



# Change life-cycle

I never work on the master branch directly. The reason for this is that pushing changes to the master branch causes them to go live immediately and there are very high chances that you will break something. Particularly, if you have Travis enabled, it's very common to commit a trivial fix locally, push it to master without much testing, and then realizing that you broke some corner case of your project. This has happened to me countless times, and I have promised to never commit to master directly again---yet I still do, and pretty much always something breaks...

To prevent this, I follow these steps:

* Always work on a non-master branch. Create a branch for the feature you are working on, the bug you are fixing, or the article you are drafting. It doesn't matter what your goal is, so simply create a new branch.

* Make sure the history of your branch is clean. (Ab)use `git rebase -i master` to ensure the sequence of commits you want pulled is easy to follow and that every commit does one (and only one) thing. In particular, commits of the form `Fix previous` or `Fix build` should never ever exist; merge those fixes into the relevant commits so that the history is clean at pull time.

* Always trigger Travis CI builds for your changes (hence why working on a branch is important). Push your branch to GitHub so that Travis CI picks it up and performs a build. If you have forked the repository, you may need to enable Travis CI builds on your end. Wait for a green result.

* It is OK and expected for you to `git push --force` on **non-master** branches. This is required if you need to go through the commit/test cycle more than once for any given branch after you have "fixed-up" commits to correct problems spotted in earlier builds.

* Do not send pull requests that subsume other/older pull requests. Each major change being submitted belongs in a different pull request, which is trivial to achieve if you use one branch per change as requested in this workflow.

# Commit messages

* Follow standard Git commit message guidelines. The first line has a maximum length of 50 characters, does not terminate in a period, and has to summarize the whole commit. Then a blank line comes, and then multiple plain-text paragraphs provide details on the commit if necessary with a maximum length of 72-75 characters per line. Vim has syntax highlighting for Git commit messages and will let you know when you go above the maximum line lengths.

* Use the imperative tense. Say `Add foo-bar` or `Fix baz` instead of `Adding blah`, `Adds bleh`, or `Added bloh`.

# GitHub-specific workflows

## Code reviews

* All changes will be subject to code reviews pre-merge time. In other words: all pull requests will be carefully inspected before being accepted and they will be returned to you with comments if there are issues to be fixed.

* Whenever you are ready to submit a pull request, review the *combined diff* you are requesting to be pulled and look for issues. This is the diff that will be subject to review, not necessarily the individual commits. You can view this diff in GitHub at the bottom of the `Open a pull request` form that appears when you click the button to file a pull request, or you can see the diff by typing `git diff <your-branch> master`.

## Handling bug tracker issues

* All changes pushed to `master` should cross-reference one or more issues in the bug tracker. This is particularly important for bug fixes, but also applies to major feature improvements.

* Unless you have a good reason to do otherwise, name your branch `issue-N` where `N` is the number of the issue being fixed.

* If the fix to the issue can be done *in a single commit*, terminate the commit message with `Fixes #N.` where `N` is the number of the issue being fixed and include a note in `NEWS` about the issue in the same commit. Such fixes can be merged onto master using fast-forward (the default behavior of `git merge`).

* If the fix to the issue requires *more than one commit*, do **not** include `Fixes #N.` in any of the individual commit messages of the branch nor include any changes to the `NEWS` file in those commits. These "announcement" changes belong in the merge commit onto `master`, which is done by `git merge --no-ff --no-commit your-branch`, followed by an edit of `NEWS`, and terminated with a `git commit -a` with the proper note on the bug being fixed.

# Recommended configuration

Add the following to your `~/.gitconfig` file:

```ini
[push]
        ; Assume a "centralized workflow".  This is the default since Git 2.0
        ; but you may want to set this explicitly anyway.  See git-config(1)
        ; for more details on the possible values.
        default = simple

[alias]
        ; Display the commit log and annotate each commit with the names of the
        ; affected files.
        lg = log --name-status
        
        ; Sane merge operation that creates a merge commit for the branch to
        ; explicitly record that the merge happened.
        mg = merge --no-commit --no-ff
        
        ; Make sure to preserve merge commits during a rebase.  Especially
        ; important when using the "mg" alias above.
        rb = rebase --preserve-merges
```
