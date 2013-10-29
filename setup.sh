#!/bin/bash
set -e
set -u
set -o pipefail

# Check for pre-requisites
(command -v gcc > /dev/null  && echo "[message] GCC found...") || (echo "[error] GCC not found, install via XCode." && exit 1)
(command -v brew > /dev/null && echo "[message] Homebew found...") || (echo "[error] Homebrew not found, install at http://brew.sh/" && exit 1)
(command -v git > /dev/null && echo "[message] Git found...") || (echo "[message] Git not found, installing from Homebew" && brew install git)

# Download oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    echo "[message] ~/.oh-my-zsh not found, installing from Github..." >&2
    (cd ~ && curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh 2> /dev/null | sh)
else
    echo "[message] ~/.oh-my-zsh found, not installing..." >&2
fi

# Installing futurama quotes
if [ ! -f ~/.futurama ]; then
    echo "[message] ~/.futurama not found, copying from repository..." >&2
    command -v gshuf || (echo "[message] gshuf not found, installing coreutils from Homebrew..." >&2 && brew install coreutils)
    curl -s https://raw.github.com/vsbuffalo/good-news-everyone/master/futurama.txt 2> /dev/null | \
	awk '{print $0} END{print "total quotes: "NR > "/dev/stderr"}' > ~/.futurama
else 
    echo "[message] ~/.futurama found, not creating it..." >&2
fi

# Copy over ./zshrc
if [ ! -f ~/.zshrc ]; then
    echo "[message] ~/.zshrc not found, copying from repository..." >&2
    cp ./.zshrc ~/.zshrc
else
    echo "[message] ~/.zshrc found, not copying from repository..." >&2
fi

# Copy over .gitconfig
if [ ! -f ~/.gitconfig ]; then
    echo "[message] ~/.gitconfig not found, copying from repository..." >&2
    cp .gitconfig ~
else
    echo "[message] ~/.gitconfig found, not copying from repository..." >&2
fi

# Copy over .tmux.conf
if [ ! -f ~/.tmux.conf ]; then
    echo "[message] ~/.tmux.conf not found, copying from repository..." >&2
    command -v tmux || (echo "[message] tmux not found, installing coreutils from Homebrew..." >&2 && brew install tmux)
    cp .tmux.conf ~
else
    echo "[message] ~/.tmux.conf found, not copying from repository..." >&2
fi


# Create a global Git ignore file
if [ ! -f ~/.global_ignore ]; then
    echo "[message] ~/.global_ignore not found, curling from Github..." >&2
    curl https://raw.github.com/github/gitignore/master/Global/Emacs.gitignore \
	https://raw.github.com/github/gitignore/master/Global/OSX.gitignore > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore
    git config --global color.ui true && echo "[message] Turning on Git colors..." >&2
else
    echo "[message] ~/.global_ignore found, not creating..." >&2
fi

# Create a Rprofile
if [ ! -f ~/.Rprofile ]; then
    echo "[message] ~/.Rprofile not found, copying from repository..." >&2
    cp ./.Rprofile ~
    echo "[message] Installing basic R and Bioconductor packages..." >&2
    Rscript -e "install.packages(c('ggplot2', 'plyr', 'reshape')); source('http://bioconductor.org/biocLite.R');  biocLite(c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures', 'VariantAnnotation'))"
else
    echo "[message] ~/.Rprofile found, not copying from repository..." >&2
fi
    
