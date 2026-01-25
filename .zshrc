## ----------- antigen ----------- ##
# source "$HOME/.antigen.zsh"
# antigen init ~/.antigenrc

# Disable Claude Code from adding git markers
# I like AI markers but these are too much and pollute 
# git history.
export CLAUDE_NO_GIT_MARKERS=1

## ----------- antidote ----------- ##
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

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

# add LaTeX
export PATH=$PATH:/usr/local/texlive/2016basic/bin/x86_64-darwin/:/usr/texbin

# LLVM config (installed from homebrew)
export LLVM_CONFIG="/opt/homebrew/opt/llvm/bin/llvm-config"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# Set compiler flags
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# Add my helper scripts
export PATH=$HOME/projects/helpers/bin/:$PATH

export PATH="$HOME/.azure-helpers/bin:$PATH"

# Initiate direnv
# see: https://direnv.net/
eval "$(direnv hook zsh)"

## ----------- custom aliases ----------- ##
function cdp() {
    cd ~/projects/$1
}
function cdw() {
    cd ~/projects/work/$1
}
function cdm() {
    cd ~/projects/personal/$1
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

alias n=nvim
export EDITOR=nvim

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

## ----------- making scp commands ----------- ##
# if you want to get abs file path
#

## ----------- jupyter stuff ----------- ##
excel() {
    if [[ $1 == *.csv || $1 == *.xlsx || $1 == *.xls || $1 == *.xlsm || $1 == *.xltx || $1 == *.xltm ]]; then
        open -a "/Applications/Microsoft Excel.app" "$1"
    else
        echo "Please provide a valid Excel file (csv, xlsx, xls, xlsm, xltx, xltm)"
    fi
}

#
## ----------- jupyter stuff ----------- ##

# look at a few stderr files in less
cdnv() {
    cd ~/.config/nvim/
}


# this is for opening up jupyter lab instances in chrome
app() {
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --app="$1"
}

## ----------- snakemake stuff ----------- ##
# for snakemake-style log directories, e.g. logs/error logs/out,
# get the most recent files
#
##

get_error_logs() {
  find logs/error/ -maxdepth 1 -name "*.err" -type f -printf '%f\t%s bytes\t%t\n'
}

get_out_logs() {
  find logs/out/ -maxdepth 1 -name "*.out" -type f -printf '%f\t%s bytes\t%t\n'
}

NL=20
logs() {
  ((echo "-- error --"; (get_error_logs | tail -n $NL)); (echo "-- out --"; (get_out_logs | tail -n $NL)))
}

# look at the last stderr log in less
lerr() {
    less logs/error/$(ls -Art logs/error/ | tail -n 1)
}

# look at the last stdout log in less
lout() {
    less logs/out/$(ls -Art logs/out/ | tail -n 1)
}

# look at a few stderr files in less
lserr() {
	get_error_logs | cut -f1 | sed 's/^/logs\/error\//' | tail -n10 | xargs | xargs less
}

# look at a few stdout files in less
lsout() {
	get_out_logs | cut -f1 | sed 's/^/logs\/out\//' | tail -n10 | xargs | xargs less
}

## ----------- bioinformatics + lazy typing ----------- ##
total_bp() {
  bioawk -cbed 'BEGIN {a=0} { a+=$end-$start } END {print a}' $1
}

percent_genome() {
    bioawk -cbed 'BEGIN{a=0} {a+=$end-$start} END{printf("%g.2%%\n", 100*a/3117275501)}' $1
}

## ----------- history stuff ----------- ##
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

## ----------- autocompletetion ----------- ##
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


. "$HOME/.local/bin/env"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/vsb/.opam/opam-init/init.zsh' ]] || source '/Users/vsb/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
