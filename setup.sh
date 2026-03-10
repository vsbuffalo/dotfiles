#!/bin/bash
set -e
set -u

red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
reset=`tput sgr0`

MACHINE_HOST="$(hostname -s)"

# Usage: on_host thuja
function on_host { [[ "$MACHINE_HOST" == "$1" ]]; }

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
    yecho "$1 not found, installing via homebrew..." && brew install "$@"
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
      ln -s ~/dotfiles/$file ~/$file
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
[[ $(basename $(pwd)) == "dotfiles" ]] ||
  recho "doesn't look like you're in dotfiles/"

# check that the key pre-requisites are met:
check_preq gcc

# install Homebrew main programs if on a mac
if [[ "$(uname)" == "Darwin" ]]; then
	check_preq brew
	install_brew fd
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
    install_brew age
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
    install_brew psgrep
    install_brew font-hack-nerd-font --force
    install_brew node
    install_brew dprint
fi

# thuja-only tools (home server / personal network)
if on_host thuja; then
  install_brew tailscale
  install_brew cloudflared
fi

# Go-installed tools (gatus: thuja only)
if on_host thuja; then
  if command -v go > /dev/null; then
    if [ -f "$HOME/.local/bin/gatus" ]; then
      gecho "gatus found..."
    else
      yecho "gatus not found, installing via go..." && \
        GOBIN="$HOME/.local/bin" go install github.com/TwiN/gatus/v5@latest
    fi
    mkdir -p "$HOME/.local/share/gatus"
  else
    wecho "go not found, skipping Go tool installs"
  fi
else
  wecho "skipping gatus install (thuja only)"
fi

# link over git stuff
linkdotfile .gitconfig

# link tmux config
linkdotfile .tmux.conf

# link config directory (including NeoVim settings)
linkdotfile .config

# link Ghostty config (macOS reads from Application Support, not .config)
ghostty_target="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
ghostty_source="$HOME/dotfiles/.config/ghostty/config"
if [ ! -L "$ghostty_target" ]; then
  mkdir -p "$(dirname "$ghostty_target")"
  [ -f "$ghostty_target" ] && mv "$ghostty_target" "$ghostty_target.bak"
  ln -s "$ghostty_source" "$ghostty_target"
  yecho "Linked Ghostty config"
fi

# link manual zsh
linkdotfile .zshrc
linkdotfile .zsh-plugins

# link R stuff
linkdotfile .Rprofile

# Link Claude Code settings (selective — skip runtime data)
link_into_dir ~/dotfiles/.claude ~/.claude \
  settings.json \
  settings.local.json \
  skills \
  commands \
  agents

# Link svc CLI
mkdir -p "$HOME/.local/bin"
svc_target="$HOME/.local/bin/svc"
if [ ! -L "$svc_target" ]; then
  ln -s "$HOME/dotfiles/bin/svc" "$svc_target"
  yecho "Linked svc"
else
  gecho "svc already linked..."
fi

# Link gatus LaunchAgent (thuja only)
if on_host thuja; then
  gatus_plist="$HOME/Library/LaunchAgents/com.gatus.serve.plist"
  if [ ! -L "$gatus_plist" ]; then
    ln -s "$HOME/.config/services/com.gatus.serve.plist" "$gatus_plist"
    yecho "Linked gatus LaunchAgent"
  else
    gecho "gatus plist already linked..."
  fi
fi

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

# get TPM (tmux plugin manager)
if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
  gecho "tpm already installed..."
else
  yecho "Installing tpm (tmux plugin manager)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# install TPM plugins headlessly
"$HOME/.tmux/plugins/tpm/bin/install_plugins" && gecho "tmux plugins installed..." || wecho "tmux plugin install failed (tmux may not be running)"

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



