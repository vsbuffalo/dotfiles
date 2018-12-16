## source prezto ##
if [[ -s "${ZDOTDIR:-$HOME}/dotfiles/prezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/dotfiles/prezto/init.zsh"
fi

if [[ "$(uname)" == "Darwin" ]]; then
    export PATH=$PATH:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/opt/X13/bin
    # add LaTeX
    export PATH=$PATH:/usr/local/texlive/2016basic/bin/x86_64-darwin/:/usr/texbin
    # add anaconda/miniconda
    export PATH="$HOME/miniconda3/bin:$PATH"
    #export PATH="$HOME/anaconda3/bin/:$PATH"
    CONDA_TYPE=miniconda
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    # linux settings
    export PATH=/home/vinceb/anaconda3/bin:$PATH
fi

ditch_conda() {
  echo $PATH | tr ':' '\n' | grep -v $CONDA_TYPE | xargs | tr ' ' ':'
}

export PATH_CONDA=$PATH
export PATH_NO_CONDA=$(ditch_conda)

con() {
  echo 'adding anaconda to $PATH...'
  export PATH=$PATH_CONDA
}

coff() {
  echo 'removing anaconda from $PATH...'
  export PATH=$PATH_NO_CONDA
}

coff_nomessage() {
  export PATH=$PATH_NO_CONDA
}

# turn off anaconda by default; don't message
coff_nomessage

## theme ##
autoload -Uz promptinit
promptinit
prompt steeef

## set history size ##
HISTSIZE=100000
SAVEHIST=100000

## custom aliases ##
alias ll="ls -larth"
alias -s txt=less
alias df="df -h"
alias du="du -h"
alias grep="grep --color"
alias today="date +%F"
alias gl="git pull --rebase"
alias g=git
alias h=brew
alias c=conda
agr () { ag $1 --ignore="*.html" } 

# get my IP
myip () { ifconfig | grep "inet " | awk '{ print $2 }' | grep -v "^127" } 

# less for stderr
sess () { $1 2>&1 >/dev/null | less }

# update prezto
update_prezto() {
  cd $ZPREZTODIR
  git pull
  git submodule update --init --recursive
}

## set editors ##
export EDITOR=vim
# alias vim to neovim and old vim to shitvim
alias vim=nvim
alias shitvim=vim
harrass() {
  echo "you're fucking kidding, right?"
}
alias emacs=harrass

## utilities for random numbers ##
rand () {
  echo $(head -1 /dev/urandom | od -N 10 | awk '{print $2}')
}

gsl_rand() {
  export GSL_RNG_SEED=$(rand)
}

## futurama quotes
futurama() {
  # dose of Futurama
  gshuf -n1 ~/.futurama 
}
[[ -e "~/.futurama" ]] &&  futurama

# syntax highlighting for less
LESSOPEN="|/usr/local/bin/lesspipe.sh %s"; export LESSOPEN  #(sh like shells)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

nag () {
  ag $1 --ignore="*.html" --ignore="*.ipynb"
}

# shell integration for zsh/iTerm2
source ~/.iterm2_shell_integration.zsh
