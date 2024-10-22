# My Dotfiles

This directory contains the dotfiles of some programs for my system (archlinux)

## Requirements

Ensure you have `git` and `stow` installed on your system:

```shell
sudo pacman -S git stow
```

## Installation

First, check out the dotfiles repo in your $HOME directory using git:

```shell
git clone git@github.com/fervflow/dotfiles.git && cd dotfiles
```

Then use GNU stow to create symlinks:

```shell
stow .
```

Or, to overwrite into existing files:

```bash
stow -R .
```

