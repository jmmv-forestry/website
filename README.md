# jmmv.github.io

This repository contains Julio Merino's personal homepage.

## Setup

Run `./configure` to prepare the tree for a build.  This is necessary to
find the correct Jekyll binary to use, as the binary name can vary across
platforms.

## Build

The site can be built in two different versions: `prod` and `dev`.  The
`prod` version builds the site for publication in its final form, while
the `dev` version builds a lighter site (no Analytics nor Disqus, for
example) and includes all posts in the tree.

The default `build` and `serve` targets build the site for the `dev`
environment.  Use `build-prod` and `serve-prod` to build the site for
the `prod` environment.
