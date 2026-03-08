## ----------- vendored plugins ----------- ##
# Sourced from dotfiles repo — no network dependency, auditable via git diff.
# Update: make -C ~/.zsh-plugins update && make -C ~/.zsh-plugins audit
ZPLUGIN_DIR="${ZDOTDIR:-$HOME}/.zsh-plugins/vendor"
if [[ -d "$ZPLUGIN_DIR" ]] && ls "$ZPLUGIN_DIR"/*/*.plugin.zsh &>/dev/null; then
    for _plugin_dir in "$ZPLUGIN_DIR"/*(N/); do
        fpath+=("$_plugin_dir")
        for _init in "$_plugin_dir"/*.plugin.zsh(N) "$_plugin_dir"/init.zsh(N); do
            source "$_init"
            break
        done
    done
    unset _plugin_dir _init
else
    echo "[dotfiles] zsh plugins not cloned yet. Run: make -C ~/.zsh-plugins clone"
fi

## ----------- basic stuff ----------- ##
bindkey -e # emacs bindings

## ----------- path stuff ----------- ##
#
# this source bin is for compiled source and/or
# bootloaders/ recipes -- this has priority
# since some servers have old stuff
export PATH=$HOME/src/bin:$PATH

# main paths if they're not there
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin/:~/.local/bin/:$PATH

# add rust stuff
export PATH=$HOME/.cargo/bin:$PATH

# add LaTeX (MacTeX / texlive)
export PATH=$PATH:/usr/local/texlive/2025/bin/universal-darwin

# LLVM config (installed from homebrew)
export LLVM_CONFIG="/opt/homebrew/opt/llvm/bin/llvm-config"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# Set compiler flags
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Add my helper scripts
export PATH=$HOME/projects/helpers/bin/:$PATH

# Add dotfiles scripts
export PATH=$HOME/dotfiles/scripts:$PATH

export PATH="$HOME/.azure-helpers/bin:$PATH"

# Initiate direnv
# see: https://direnv.net/
eval "$(direnv hook zsh)"

## ----------- custom aliases ----------- ##
function cdp() {
    cd ~/projects/personal/$1
}
function cdw() {
    cd ~/projects/work/$1
}
alias less="bat"
alias la="eza  -la --icons --sort date"
alias ll="eza  -l --icons --sort date"
alias ld="eza  -l --icons --sort date ~/Downloads"
alias sz="source ~/.zshrc"
alias oo="open ."
alias ct="eza --tree --git-ignore \
  --ignore-glob='*.pyc|*.pyo|__pycache__|*.egg-info|.mypy_cache|.venv|.tox|target|Cargo.lock|*.rs.bk|*.rmeta|*.dSYM|node_modules|.DS_Store|*.log' \
  --icons"
alias df="df -h"
alias du="du -h"
alias grep="grep --color"
alias today="date +%F"
alias ip="ipconfig getifaddr en0"
alias now="date -u +'%Y-%m-%dT%H:%M:%SZ'"
alias gl="git pull --rebase"
alias g=git
alias h=brew
alias git-whoami='
  if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "📧 $(git config user.email)"
    echo "📝 from: $(git config --show-origin user.email | cut -f1)"
  else
    echo "❌ Not inside a Git repository." >&2
    return 1
  fi
'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

## ----------- autocompletetion ----------- ##
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

## ----------- tmux project sessions ----------- ##
tp() {
  local name dir
  if [[ -n "$1" ]]; then
    name="$1"
    for base in ~/projects/personal ~/projects/work; do
      [[ -d "$base/$name" ]] && { dir="$base/$name"; break; }
    done
    [[ -z "$dir" ]] && { echo "tp: project '$name' not found" >&2; return 1; }
  else
    dir=$(find ~/projects/personal ~/projects/work -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
      | fzf --prompt="project> " --preview 'ls {}') || return
    name=$(basename "$dir")
  fi

  if tmux has-session -t "$name" 2>/dev/null; then
    tmux attach-session -t "$name"
    return
  fi

  tmux new-session -d -s "$name" -n main -c "$dir"
  tmux split-window -h -t "$name:main" -c "$dir"
  tmux select-pane -t "$name:main.1"
  tmux attach-session -t "$name"
}

_tp() {
  local dirs=()
  for d in ~/projects/{personal,work}/*(N/); do dirs+=("${d:t}"); done
  compadd -a dirs
}
compdef _tp tp

dewey() {
  local greet="On your first response, briefly introduce yourself as Dewey the dotfiles librarian and list your available slash commands. Keep it to 2-3 lines."
  (cd ~/dotfiles && claude --append-system-prompt "$greet" "${*:-hi}")
}

alias mdfmt='dprint fmt --config-discovery=global'
alias nv=nvim
export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export BAT_PAGER="less -RF"

# alias vim to neovim if possible, warn otherwise
if (( $+commands[nvim] )); then
  alias vim=nvim
else
  echo '[warning] nvim not found!'
fi

## ----------- dark mode ----------- ##
# Function to toggle between dark and light mode
toggle_dark_mode() {
  # Check current appearance mode
  current_mode=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
  
  if [[ $current_mode == "Dark" ]]; then
    # Switch to light mode
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to false'
    echo "Switched to Light Mode"
  else
    # Switch to dark mode
    osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'
    echo "Switched to Dark Mode"
  fi
}

# Alias for the toggle_dark_mode function
alias darkmode=toggle_dark_mode

## ----------- weather stuff ----------- ##
alias weather="curl wttr.in/Seattle?u"

## ----------- file openers ----------- ##
excel() {
    if [[ $1 == *.csv || $1 == *.xlsx || $1 == *.xls || $1 == *.xlsm || $1 == *.xltx || $1 == *.xltm ]]; then
        open -a "/Applications/Microsoft Excel.app" "$1"
    else
        echo "Please provide a valid Excel file (csv, xlsx, xls, xlsm, xltx, xltm)"
    fi
}

cdnv() {
    cd ~/.config/nvim/
}


# this is for opening up jupyter lab instances in chrome
app() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app="$1"
}

## ----------- history stuff ----------- ##
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=100000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Append-only archive with timestamps — preserves frequency data for analysis.
# Not used by zsh for recall; just a log.
HIST_ARCHIVE=~/.zsh_history_archive
__history_archive_hook() {
  echo "${(%):-%D{%Y-%m-%dT%H:%M:%S}} ${1}" >> "$HIST_ARCHIVE"
}
autoload -Uz add-zsh-hook
add-zsh-hook zshaddhistory __history_archive_hook

. "$HOME/.local/bin/env"


# Local secrets (not tracked in dotfiles)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/vsb/.opam/opam-init/init.zsh' ]] || source '/Users/vsb/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
