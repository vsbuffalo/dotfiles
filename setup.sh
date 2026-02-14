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

# install via homebrew if not already installed (checks brew list, not command)
function install_brew {
  if brew list "$1" &>/dev/null; then
    gecho "$1 found..."
  else
    yecho "$1 not found, installing via homebrew..." && brew install "$1"
  fi
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

# Selectively symlink files from source_dir into an existing target_dir.
# Unlike linkdotfile, this works when the target dir already exists.
function link_into_dir {
  local source_dir="$1"
  local target_dir="$2"
  shift 2

  mkdir -p "$target_dir"

  for item in "$@"; do
    local src="$source_dir/$item"
    local tgt="$target_dir/$item"

    if [ ! -e "$src" ]; then
      wecho "$src not found, skipping..."
      continue
    fi

    if [ -L "$tgt" ]; then
      gecho "$item already linked..."
    elif [ -e "$tgt" ]; then
      yecho "$item exists (not a symlink), backing up to ${tgt}.bak..."
      mv "$tgt" "${tgt}.bak"
      ln -s "$src" "$tgt"
      gecho "$item linked (old version saved as ${item}.bak)"
    else
      yecho "Linking $item..."
      ln -s "$src" "$tgt"
    fi
  done
}

# are we in right directory?
[[ $(basename $(pwd)) == "dotfiles2" ]] ||
  recho "doesn't look like you're in dotfiles2/"

# check that the key pre-requisites are met:
check_preq gcc

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
    install_brew delta
    install_brew opam
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
    install_brew dprint
fi

# link over git stuff
linkdotfile .gitconfig

# link config directory (including NeoVim settings)
linkdotfile .config

# linkover .condarc (commented out - using uv/pixi instead)
# linkdotfile .condarc

# link manual zsh
linkdotfile .zshrc
linkdotfile .zsh_plugins.txt

# link R stuff
linkdotfile .Rprofile

# Link Claude Code settings (selective — skip runtime data)
link_into_dir ~/dotfiles2/.claude ~/.claude \
  settings.json \
  settings.local.json \
  skills \
  commands \
  agents

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

# get antidote for zsh
if [[ -d "${ZDOTDIR:-$HOME}/.antidote" ]]; then
  gecho "antidote already installed..."
else
  yecho "Installing antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "${ZDOTDIR:-$HOME}/.antidote"
fi

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

# OCaml setup via opam
if command -v opam > /dev/null; then
    gecho "Setting up OCaml via opam..."
    # Initialize opam if not already done
    if [[ ! -d "$HOME/.opam" ]]; then
        yecho "Initializing opam..."
        opam init --auto-setup --yes
    else
        gecho "opam already initialized..."
    fi
    eval "$(opam env)"
    opam update
    # Create default switch with OCaml 5.4.0 (skip if exists)
    if opam switch list | grep -q "default"; then
        gecho "default switch exists..."
        opam switch set default
    else
        yecho "Creating default switch with OCaml 5.4.0..."
        opam switch create default 5.4.0 --yes
    fi
    eval "$(opam env)"
    # Core dev tools (no merlin needed with LSP)
    opam install dune ocaml-lsp-server ocamlformat utop odoc --yes
else
    wecho "opam not found, skipping OCaml setup"
fi



