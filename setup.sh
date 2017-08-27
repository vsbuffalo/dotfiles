#!/bin/bash
set -e
set -u

RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

## printing functions ##
function gecho {
  echo "${Gre}[message] $1${RCol}"
}

function yecho {
  echo "${Yel}[warning] $1${RCol}"
}

function wecho {
  # red, but don't exit 1
  echo "${Red}[error] $1${RCol}"
}


function recho {
  echo "${Red}[error] $1${RCol}"
  exit 1
}

## install functions ##

# check for pre-req, fail if not found
function check_preq {
  (command -v $1 > /dev/null  && gecho "$1 found...") || 
    recho "$1 not found, install before proceeding."
}

# look for command line tool, if not install via homebrew
function install_brew {
  (command -v $1 > /dev/null  && gecho "$1 found...") || 
    (yecho "$1 not found, installing via homebrew..." && brew install $1)
}

# function for linking dotfiles
function linkdotfile {
  file="$1"
  if [ ! -e ~/$file -a ! -L ~/$file ]; then
      yecho "$file not found, linking..." >&2
      ln -s ~/dotfiles/$file ~/$file
  else
      gecho "$file found, ignoring..." >&2
  fi
}

# check that the key pre-requisites are met:
check_preq gcc
check_preq brew
check_preq "command -v ~/anaconda/bin/conda"

# install Homebrew main programs
install_brew ag
install_brew tmux
install_brew nvim
install_brew zsh

yecho "linking prezto files..." >&2
zsh install_prezto.zsh

exit 1

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
linkdotfile .gitattributes

# Link over .latexmkrc for latexmk settings
linkdotfile .latexmkrc

# Link over .tmux.conf
linkdotfile .tmux.conf

# Create Python setup
linkdotfile .pythonrc.py

# Link NeoVim settings
linkdotfile .config

# Create a Rprofile
linkdotfile .Rprofile

# Create zsh completion
linkdotfile .zsh-completions

# Create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "~/.global_ignore not found, curling from Github..." >&2
    curl https://raw.github.com/github/gitignore/master/Global/Emacs.gitignore \
    https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore \
    https://raw2.github.com/github/gitignore/master/Global/vim.gitignore \
    https://raw.github.com/github/gitignore/master/Global/OSX.gitignore \
    https://raw.githubusercontent.com/github/gitignore/master/TeX.gitignore > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore && yecho "[message] adding ignore file to Git..." >&2
else
    gecho "~/.global_ignore found, ignoring..." >&2
fi

# Install nosetests and stuff
pip install nose 2> /dev/null
pip install yanc 2> /dev/null
linkdotfile .noserc

# Install some R packages
gecho "installing basic R and Bioconductor packages..." >&2
Rscript "dotfiles/install_rpkgs.R"

yecho "run the following to change shell to zsh... :" >&2
echo "  chsh -s /bin/zsh "


