# stg1

[Stacked Git](https://github.com/stacked-git/stgit), **StGit** for short, is an
application for managing Git commits as a stack of patches.

`stg1` is a fork of StGit version 1.5, i.e. before StGit was rewritten in Rust.

With a *patch stack* workflow, multiple patches can be developed
concurrently and efficiently, with each patch focused on a single
concern, resulting in both a clean Git commit history and improved
productivity.

For a complete introduction to StGit, see the [Stacked Git
homepage](https://stacked-git.github.io).

## Getting started

To get a feel for how StGit works, see this brief [example of StGit in
action][example]. Or check out the [in-depth tutorial][tutorial].

[example]: https://stacked-git.github.io/guides/usage-example
[tutorial]: https://stacked-git.github.io/guides/tutorial

StGit also has a complete set of [man pages][man] describing the
[`stg`][stg] command line tool and each of its subcommands.

[man]: https://stacked-git.github.io/man
[stg]: https://stacked-git.github.io/man/stg

## Installation

See [CHANGELOG.md](CHANGELOG.md) to see what has changed in the latest
StGit release.

### Dependencies

StGit is written in pure Python with no third-party Python dependencies.
StGit supports Python versions >= 3.5.

StGit works within the context of a Git repository by running `git`
commands. [Git](https://git-scm.com) 2.2.0 or newer is required.

### Source Installation

StGit may also be installed from source. Download the [latest
release][latest] or clone from the [StGit repository on GitHub][repo].

[latest]: https://github.com/stacked-git/stgit/releases/latest
[repo]: https://github.com/stacked-git/stgit

To install from source, choose a `prefix` and run:

``` shellsession
$ make prefix=/usr/local install install-doc
```

For more information about installation, see [INSTALL](INSTALL).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for a full guide to contributing
to StGit.

## Maintainers

stg1 is maintained by J. Neuschäfer.

Special thanks to Catalin Marinas and Peter Grayson.

For a complete list of StGit's authors, see [AUTHORS.md](AUTHORS.md).
