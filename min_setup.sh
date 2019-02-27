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

# are we in right directory?
[[ $(basename $(pwd)) == "dotfiles" ]] || 
  recho "doesn't look like you're in dotfiles/"

# check that the key pre-requisites are met:
# since this script is system agnostic, we fail if 
# these aren't installed, and ask user to install
# manually
check_preq nvim
check_preq "command -v ~/anaconda/bin/conda"

yecho "linking prezto files..." >&2
zsh install_prezto.zsh

# link over .gitconfig
linkdotfile .gitconfig
linkdotfile .gitattributes

# link over .tmux.conf
linkdotfile .tmux.conf

# link NeoVim settings
linkdotfile .config

# create a Rprofile
linkdotfile .Rprofile

# create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "~/.global_ignore not found, curling from Github..." >&2
    curl \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Emacs.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/TeX.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Python.gitignore \
    > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore && 
      yecho "[message] adding ignore file to Git..." >&2
else
    gecho "~/.global_ignore found, ignoring..." >&2
fi

yecho "run the following to change shell to zsh... :" >&2
echo "  chsh -s /bin/zsh "


