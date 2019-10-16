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
check_preq gcc
check_preq brew
check_preq "command -v ~/anaconda/bin/conda"

# install Homebrew main programs
install_brew ag
install_brew tmux
install_brew nvim
install_brew zsh
install_brew lesspipe
install_brew joe
install_brew libgit2

yecho "linking prezto files..." >&2
zsh install_prezto.zsh

# installing futurama quotes
if [ ! -e ~/.futurama ]; then
  yecho ".futurama not found, downloading..." >&2
  curl -s https://raw.githubusercontent.com/vsbuffalo/good-news-everyone/master/futurama.txt 2> /dev/null | \
    awk '{print $0} END{print "total quotes: "NR > "/dev/stderr"}' > ~/.futurama
else
  gecho ".futurama found, ignoring..." >&2
fi

# link over .gitconfig
linkdotfile .gitconfig
linkdotfile .gitattributes

# link over .latexmkrc for latexmk settings
linkdotfile .latexmkrc

# link over .tmux.conf
linkdotfile .tmux.conf

# create Python setup
linkdotfile .ipython
linkdotfile .ptpython
linkdotfile .condarc

# link NeoVim settings
linkdotfile .config

# create a Rprofile
linkdotfile .Rprofile

# create zsh completion
linkdotfile .zsh-completions

# iterm integration
linkdotfile .iterm2_shell_integration.zsh

# create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "~/.global_ignore not found, curling from Github..." >&2
    curl \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Emacs.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore \
    > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore && 
      yecho "[message] adding ignore file to Git..." >&2
else
    gecho "~/.global_ignore found, ignoring..." >&2
fi

## install nosetests and stuff
#pip3 install nose 2> /dev/null
#pip3 install yanc 2> /dev/null
#pip3 install joe 2> /dev/null
#linkdotfile .noserc

# install some R packages
gecho "installing basic R and Bioconductor packages..." >&2
Rscript ~/dotfiles/install_rpkgs.r

yecho "run the following to change shell to zsh... :" >&2
echo "  chsh -s /bin/zsh "


