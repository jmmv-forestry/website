---
layout:      post
title:       Common Makefile pitfalls
categories:  development
---

Post a recollection of issues with little snippets on each. Use the form:

What's wrong with this snippet? … And then tell the reason.

# Changes to build rules do not trigger rebuild

Makefiles do not track the build rules, so if they change, the target is not rebuilt. Think of the manpage generation targets I have and what happens if configure modifies any of the variables.

# Temporary files as part of a rule

What happens when you do `>foo.out` from a rule and the command to generate this fails? `foo.out` has a newer timestamp so the rule is assumed to have succeeded on the next build. Running make after the failure won't regenerate the file.

# 
