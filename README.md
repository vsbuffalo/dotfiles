# dotfiles

Here are my dotfiles and general instructions on how I set up my **Mac OS X**
laptops (this will *not* work for Linux).

## Prerequisites

1. Install OS X Command Line Tools. Homebrew will also try to do 
   this automatically.
2. Install Anaconda. [Download link](https://www.anaconda.com/download/) (I use
   the Python 3 version) and [installation
   instructions](https://docs.continuum.io/anaconda/install/mac-os#macos-graphical-install).
   Be sure to install for a single user on OS X only; the system-wide installs
   cause issues with permissions. This cannot be done via the command line.

## Bootstrapping a new installation

Clone this repository to the `~` directory and use the following to install:

    $ sh setup.sh

This script does the following:

 - Installs Git, NeoVim, Ag, and tmux (from Homebrew, since these are
   dependencies)
 - Installs ~oh-my-zsh~ [pretzo](https://github.com/sorin-ionescu/prezto)
 - Installs [Futurama quotes](https://github.com/vsbuffalo/good-news-everyone)
 - Installs `~/.zshrc`
 - Links `~/.gitconfig`
 - Links `~/.tmux.conf`
 - Creates `~/.global_ignore` from Github's `.gitignore` files and sets up Git
   colors
 - Links `~/.Rprofile` and installs some R packages
 - Stores and links NeoVim's files (see below).

## Installed R and Bioconductor Packages

See `install_rpkgs.R`:

 - ggplot2
 - plyr
 - reshape
 - BiocInstaller
 - GenomicRanges
 - ggbio
 - Gviz
 - GenomicRanges
 - VariantAnnotation

## NeoVim

Annoyed with Emacs running evil-mode (and clashing with packages like polyweb),
I decided to try [NeoVim](http://neovim.io/). I'm happy to report that it's
terrific, and is likely my permanent text editor. Using the
[vim-rsi](https://github.com/tpope/vim-rsi) plugin, I can use emacs mappings in
insert mode (this is a big deal). There's also great support for Ag, Git
through fugitive, really terrific Python, C/C++ completion through the
unbeatable [YouCompleteMe](https://github.com/Valloric/YouCompleteMe), and some
hacky vimscript I wrote to send lines of code to the new, awesome NeoVim
terminal. You can see all of my configurations in `.nvim*`. I will keep my old
Vim configurations around too.


## Pretzo

Recently, I have migrated from oh-my-zsh to pretzo.

    git submodule add https://github.com/sorin-ionescu/prezto.git
    git submodule update --init --recursive

## Sane Jupyter Notebook Diffs

From Erick Matsen: https://gist.github.com/matsen/37521f504a14aede644d
