#!/bin/bash
set -e
set -u

RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

function gecho {
    echo "${Gre}$1${RCol}"
}

function yecho {
    echo "${Yel}$1${RCol}"
}

function recho {
    echo "${Red}$1${RCol}"
}


# Check for pre-requisites
(command -v gcc > /dev/null  && gecho "[message] GCC found...") || (recho "[error] GCC not found, install via XCode." && exit 1)
(command -v brew > /dev/null && gecho "[message] Homebew found...") || (recho "[error] Homebrew not found, install at http://brew.sh/" && exit 1)
(command -v git > /dev/null && gecho "[message] Git found...") || (yecho "[message] Git not found, installing from Homebew" && brew install git)

# Download oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    yecho "[message] ~/.oh-my-zsh not found, installing from Github..." >&2
    (cd ~ && curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh 2> /dev/null | sh)
else
    gecho "[message] ~/.oh-my-zsh found, ignoring..." >&2
fi

# Installing futurama quotes
if [ ! -e ~/.futurama ]; then
    yecho "[message] ~/.futurama not found, downloading..." >&2
    command -v gshuf || (yecho "[message] gshuf not found, installing coreutils from Homebrew..." >&2 && brew install coreutils)
    curl -s https://raw.github.com/vsbuffalo/good-news-everyone/master/futurama.txt 2> /dev/null | \
	awk '{print $0} END{print "total quotes: "NR > "/dev/stderr"}' > ~/.futurama
else 
    gecho "[message] ~/.futurama found, ignoring..." >&2
fi

# Copy over ./zshrc
if [ ! -e ~/.zshrc -a ! -L ~/.zshrc ]; then
    yecho "[message] ~/.zshrc not found, linking..." >&2
    ln -s dotfiles/.zshrc ~/.zshrc
else
    gecho "[message] ~/.zshrc found, ignoring..." >&2
fi

# Copy over .gitconfig
if [ ! -e ~/.gitconfig -a ! -L ~/.gitconfig ]; then
    yecho "[message] ~/.gitconfig not found, linking..." >&2
    ln -s dotfiles/.gitconfig ~/.gitconfig
else
    gecho "[message] ~/.gitconfig found, ignoring..." >&2
fi

# Copy over .tmux.conf
if [ ! -e ~/.tmux.conf -a ! -L ~/.tmux.conf ]; then
    command -v tmux > /dev/null || (yecho "[message] tmux not found, installing coreutils from Homebrew..." >&2 && brew install tmux)
    ln -s dotfiles/.tmux.conf ~/.tmux.conf
    yecho "[message] ~/.tmux.conf not found, linking..." >&2
else
    gecho "[message] ~/.tmux.conf found, ignoring..." >&2
fi


# Create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "[message] ~/.global_ignore not found, curling from Github..." >&2
    curl https://raw.github.com/github/gitignore/master/Global/Emacs.gitignore \
	https://raw.github.com/github/gitignore/master/Global/OSX.gitignore > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore
    git config --global color.ui true && yecho "[message] turning on Git colors..." >&2
else
    gecho "[message] ~/.global_ignore found, ignoring..." >&2
fi

# Create a Rprofile
if [ ! -e ~/.Rprofile -a ! -L ~/.Rprofile ]; then
    yecho "[message] ~/.Rprofile not found, linking..." >&2
    ln -s dotfiles/.Rprofile ~/.Rprofile
    yecho "[message] installing basic R and Bioconductor packages..." >&2
    
    Rscript -e "install.packages(c('ggplot2', 'plyr', 'reshape')); source('http://bioconductor.org/biocLite.R');  biocLite(c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures', 'VariantAnnotation'))" || (recho "[error] could not install R packages - is R installed?" && exit 1)
else
    gecho "[message] ~/.Rprofile found, ignoring..." >&2
fi

# Create Python setup
if [ ! -e ~/.pythonrc.py -a ! -L ~/.pythonrc.py ]; then
    yecho "[message] ~/.pythonrc.py not found, linking..." >&2    
    ln -s dotfiles/.pythonrc.py ~/.pythonrc.py
else
    gecho "[message] ~/.pythonrc.py found, ignoring..." >&2
fi
