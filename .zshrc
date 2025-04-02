## ----------- antigen ----------- ##
# source "$HOME/.antigen.zsh"
# antigen init ~/.antigenrc

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
alias ll="ls -larth --color"
alias ct="exa --tree --git-ignore \
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

alias n=nvim
export EDITOR=nvim

# alias vim to neovim if possible, warn otherwise
if (( $+commands[nvim] )); then
  alias vim=nvim
else
  echo '[warning] nvim not found!'
fi

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
