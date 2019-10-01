# dotfiles

Here are my dotfiles and general instructions on how I set up my **Mac OS X**
laptops (this will *not* work for Linux).

## Prerequisites

1. Install OS X Command Line Tools. Homebrew will also try to do 
   this automatically.
2. Install [homebrew](https://brew.sh), then install git (to clone this repo):

        brew install git
        
3. Install Anaconda. [Download link](https://www.anaconda.com/download/) (I use
   the Python 3 version) and [installation
   instructions](https://docs.continuum.io/anaconda/install/mac-os#macos-graphical-install).
   Be sure to install for a single user on OS X only; the system-wide installs
   cause issues with permissions. This cannot be done via the command line.
   

## Bootstrapping a new installation

For a new OS X development environment, clone this repository to the 
`~` directory and use the following to install:

    git clone --recursive git@github.com:vsbuffalo/dotfiles.git
    cd dotfiles
    sh setup.sh

If you forget `--recursive` (as I often do), use:

    git submodule update --init --recursive

This script does the following:

 - Installs Git, NeoVim, Ag, zsh, lesspipe, and tmux (from Homebrew, since
   these are dependencies)
 - Installs ~oh-my-zsh~ [pretzo](https://github.com/sorin-ionescu/prezto)
 - Installs [Futurama quotes](https://github.com/vsbuffalo/good-news-everyone)
 - Links `~/.zshrc` to `dotfiles/zshrc`
 - Links `~/.gitconfig`
 - Links `~/.tmux.conf`
 - Links `~/.ipython/`
 - Creates `~/.global_ignore` from Github's `.gitignore` files and sets up Git
   colors
 - Links `~/.Rprofile` and installs some R packages
 - Stores and links NeoVim's files (see below).
 - Installs [joe](https://github.com/karan/joe), which is a nifty tool for getting gitignore files.

## Things to do manually after a new bootstrap

1. Set up a conda profile (e.g. basesci), install ipython, etc.


## Linux minimum environment

For Linux, a minimum environment is set up. Since `yum` or `apt-get` may be
used, this boostraph script does not install anything itself. This expects neovim and zsh 
to be installed, and copies over the configuration files of both (and creates global git ignore
files, etc). Run:

    sh min_setup.sh

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

If YouCompleteMe install isn't working:

```
xcrun -find c++
xcrun -find cc
export CC=`which cc`;export CXX=/Library/Developer/CommandLineTools/usr/bin/c++;./install.py --clang-completer
```


## Pretzo

Recently, I have migrated from oh-my-zsh to pretzo.

    git submodule add https://github.com/sorin-ionescu/prezto.git
    git submodule update --init --recursive

I then link my own `dotfiles/.zshrc` to `~`, not the one included in
`dotfiles/prezto/runcoms/`. See `install_prezto.zsh` for more info -- this is
adopted from the pretzo readme.

If you need to update Pretzo:

    cd $ZPREZTODIR
    git pull
    git submodule update --init --recursive
    
## Sane Jupyter Notebook Diffs

From Erick Matsen: https://gist.github.com/matsen/37521f504a14aede644d

## LaTeX

I use basic LaTeX, and then install

```
sudo tlmgr install collection-fontsrecommended
sudo tlmgr install preprint
sudo tlmgr install wasysym
sudo tlmgr install biblatex
sudo tlmgr install logreq
sudo tlmgr install xstring
sudo tlmgr install units  
```


## git-latexdiff

git@gitlab.com:git-latexd

## JupyterLab stuff:

Some good extensions are [listed here](https://github.com/mauhai/awesome-jupyterlab).

    pip install jupyterlab_latex
    jupyter labextension install jupyterlab_vim
    jupyter labextension install @jupyter-widgets/jupyterlab-manager

