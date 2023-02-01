## ----------- antigen ----------- ##
source "$HOME/.antigen.zsh"
antigen init ~/.antigenrc

## ----------- basic stuff ----------- ##
bindkey -e # emacs bindings

## ----------- path stuff ----------- ##
#
# this source bin is for compiled source and/or
# bootloaders/ recipes -- this has priority 
# since some servers have old stuff
export PATH=$HOME/src/bin:$PATH

# main paths if they're not there
export PATH=$HOME/bin:/usr/local/bin:$PATH

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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/vsb/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/vsb/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/vsb/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/vsb/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

