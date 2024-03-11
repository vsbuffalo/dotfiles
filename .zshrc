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
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin/:$PATH

# add rust stuff
export PATH=$HOME/.cargo/bin:$PATH

# add LaTeX
export PATH=$PATH:/usr/local/texlive/2016basic/bin/x86_64-darwin/:/usr/texbin

# add miniconda 
# export PATH="$HOME/miniconda3/bin:$PATH"  # commented out by conda initialize  # commented out by conda initialize

## ----------- custom aliases ----------- ##
alias ll="ls -larth"
alias df="df -h"
alias du="du -h"
alias grep="grep --color"
alias today="date +%F"
alias gl="git pull --rebase"
alias g=git
alias h=brew
alias c=conda

alias pip=pip3
alias pythin=python3

alias mi="mamba install --yes "

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

#
## ----------- jupyter stuff ----------- ##

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


## ----------- pyenv etc ----------- ##

# -- poetry completion
fpath+=~/.zfunc
autoload -Uz compinit && compinit
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
