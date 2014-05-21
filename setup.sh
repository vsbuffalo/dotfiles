#!/bin/bash
set -e
set -u

RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

function gecho {
  echo "${Gre}[message] $1${RCol}"
}

function yecho {
  echo "${Yel}[warning] $1${RCol}"
}

function recho {
  echo "${Red}[error] $1${RCol}"
  exit 1
}

# Check for pre-requisites
(command -v gcc > /dev/null  && gecho "GCC found...") || recho "GCC not found, install via XCode."
(command -v brew > /dev/null && gecho "Homebrew found...") || recho "Homebrew not found, install at http://brew.sh/"
#(brew doctor > /dev/null && gecho "brew doctor looks good...") || recho "brew doctor returned with non-zero exit status. Run brew doctor and debug."

# Install Homebrew main programs
(command -v git > /dev/null && gecho "Git found...") || (yecho "Git not found, installing from Homebrew" && brew install git)
(command -v ag > /dev/null && gecho "Ag found...") || (yecho "Ag not found, installing from Homebrew" && brew install the_silver_searcher)
(command -v tmux > /dev/null && gecho "tmux found...") || (yecho "tmux not found, installing from Homebrew" && brew install tmux)
(command -v vim > /dev/null && gecho "Vim found...") || (yecho "Vim not found, installing from Homebrew" && brew install vim)
(command -v mvim > /dev/null && gecho "MacVim found...") || (yecho "MacVim not found, installing from Homebrew" && brew install macvim --env-std --override-system-vim)

# function for linking dotfiles
function linkdotfile {
  file="$1"
  if [ ! -e ~/$file -a ! -L ~/$file ]; then
      yecho "$file not found, linking..." >&2
      ln -s dotfiles/$file ~/$file
  else
      gecho "$file found, ignoring..." >&2
  fi
}

# Download oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then
    yecho ".oh-my-zsh not found, installing from Github..." >&2
    (cd ~ && curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh 2> /dev/null | sh)
else
    gecho ".oh-my-zsh found, ignoring..." >&2
fi

# Installing futurama quotes
if [ ! -e ~/.futurama ]; then
    yecho ".futurama not found, downloading..." >&2
    command -v gshuf || (yecho "gshuf not found, installing coreutils from Homebrew..." >&2 && brew install coreutils)
    curl -s https://raw.github.com/vsbuffalo/good-news-everyone/master/futurama.txt 2> /dev/null | \
	awk '{print $0} END{print "total quotes: "NR > "/dev/stderr"}' > ~/.futurama
else
    gecho ".futurama found, ignoring..." >&2
fi

# Link over .zshrc
linkdotfile .zshrc

# Link over .gitconfig
linkdotfile .gitconfig

# Link over .tmux.conf
linkdotfile .tmux.conf

# Create Python setup
linkdotfile .pythonrc.py

# Link Vim settings
linkdotfile .vimrc
linkdotfile .vim

# Create a Rprofile
linkdotfile .Rprofile

# Create zsh completion
linkdotfile .zsh-completions

# Create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "~/.global_ignore not found, curling from Github..." >&2
    curl https://raw.github.com/github/gitignore/master/Global/Emacs.gitignore \
    https://raw2.github.com/github/gitignore/master/Global/vim.gitignore \
	https://raw.github.com/github/gitignore/master/Global/OSX.gitignore > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore && yecho "[message] adding ignore file to Git..." >&2
else
    gecho "~/.global_ignore found, ignoring..." >&2
fi

# Install some R packages
gecho "installing basic R and Bioconductor packages..." >&2
Rscript -e "install.packages(c('microbenchmark', 'ggplot2', 'plyr', 'dplyr', 'knitr', 'reshape')); source('http://bioconductor.org/biocLite.R');  biocLite(c('GenomicRanges', 'ggbio', 'Gviz', 'GenomicFeatures', 'VariantAnnotation'))" || recho "[error] could not install R packages - is R installed?"


