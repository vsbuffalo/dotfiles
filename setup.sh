#!/bin/bash
set -e
set -u

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

## printing functions ##
function gecho {
  echo "${green}[message] $1${reset}"
}

function yecho {
  echo "${yellow}[note] $1${reset}"
}

function wecho {
  # red, but don't exit 1
  echo "${red}[error] $1${reset}"
}

function recho {
  echo "${red}[error] $1${reset}"
  exit 1
}


## install functions ##

# look for command line tool, if not install via homebrew
function install_brew {
  (command -v $1 > /dev/null  && gecho "$1 found...") ||
    (yecho "$1 not found, installing via homebrew..." && brew install $1)
}

# check for pre-req, fail if not found
function check_preq {
  (command -v $1 > /dev/null  && gecho "$1 found...") ||
    recho "$1 not found, install before proceeding."
}

# function for linking dotfiles
function linkdotfile {
  file="$1"
  if [ ! -e ~/$file -a ! -L ~/$file ]; then
      yecho "$file not found, linking..." >&2
      ln -s ~/dotfiles2/$file ~/$file
  else
      gecho "$file found, ignoring..." >&2
  fi
}

# are we in right directory?
[[ $(basename $(pwd)) == "dotfiles2" ]] ||
  recho "doesn't look like you're in dotfiles2/"

# check that the key pre-requisites are met:
check_preq gcc
check_preq "command -v ~/anaconda/bin/conda"

# install Homebrew main programs if on a mac
if [[ "$(uname)" == "Darwin" ]]; then
	check_preq brew
	install_brew yazi
	install_brew duckdb
	install_brew eza
	install_brew yq
	install_brew fzf
	install_brew rg
	install_brew tmux
	install_brew awscli
	install_brew postgresql
	install_brew tree
	install_brew direnv
    # Stuff needed for various R packages
    install_brew libgit2
    install_brew libomp
    install_brew harfbuzz
    install_brew fribidi
    install_brew freetype
    install_brew cairo
    install_brew glib
    install_brew graphite2
    install_brew libpng
    install_brew libtiff
    install_brew jpeg
    install_brew pkg-config
    install_brew htop
    install_brew font-hack-nerd-font
    install_brew node
    install_brew duckdb
    install_brew dprint
    install_brew opam
fi

# link over git stuff
linkdotfile .gitconfig

# link config directory (including NeoVim settings)
linkdotfile .config

# linkover .condarc
linkdotfile .condarc

# link manual zsh
linkdotfile .zshrc
linkdotfile .zsh_plugins.txt

# link R stuff
linkdotfile .Rprofile

# link Claude Code settings
linkdotfile .claude

# Create ~/.R/Makevars with OpenMP flags — but only on macOS
if [[ "$(uname)" == "Darwin" ]]; then
  makevars_path="$HOME/.R/Makevars"
  if [[ ! -f "$makevars_path" ]]; then
      yecho "macOS detected — linking ~/.R (which includes Makevars)..." >&2
    linkdotfile .R
  else
    gecho "~/.R found, not modifying..."
  fi
else
  yecho "Non-macOS system detected — skipping ~/.R/Makevars setup."
fi

# install OCaml toolchain
if command -v opam > /dev/null; then
    if [ ! -d ~/.opam ]; then
        yecho "opam not initialized, running 'opam init'..."
        opam init -y --bare
    else
        gecho "opam already initialized..."
    fi
    gecho "installing OCaml LSP and formatter via opam..."
    eval $(opam env)
    opam install -y ocaml-lsp-server ocamlformat
else
    yecho "opam not found, skipping OCaml toolchain..."
fi

# get antidote for zsh
git clone --depth=1 https://github.com/mattmc3/antidote.git ${ZDOTDIR:-~}/.antidote

# create a global Git ignore file
if [ ! -e ~/.global_ignore ]; then
    yecho "~/.global_ignore not found, curling from Github..." >&2
    curl \
      https://raw.githubusercontent.com/github/gitignore/master/Global/Vim.gitignore \
      https://raw.githubusercontent.com/github/gitignore/master/Global/macOS.gitignore \
    > ~/.global_ignore 2> /dev/null
    git config --global core.excludesfile ~/.global_ignore &&
      yecho "[message] adding ignore file to Git..." >&2
else
    gecho "~/.global_ignore found, ignoring..." >&2
fi


