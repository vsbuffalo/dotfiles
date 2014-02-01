# dotfiles

Use the following to install:

    $ sh setup.sh

My dotfiles install process does the following (if these files/programs don't
exist):

 - Installs Git (from Homebrew)
 - Installs [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
 - Installs [Futurama quotes](https://github.com/vsbuffalo/good-news-everyone)
 - Installs `~/.zshrc`
 - Links `~/.gitconfig`
 - Links `~/.tmux.conf`
 - Creates `~/.global_ignore` from Github's `.gitignore` files and sets up Git colors
 - Links `~/.Rprofile` and installs some R packages

## Installed R and Bioconductor Packages

 - ggplot2
 - plyr
 - reshape
 - BiocInstaller
 - GenomicRanges
 - ggbio
 - Gviz
 - GenomicRanges
 - VariantAnnotation
 
## Vim

My Vim settings are also stored in `dofiles/`. Links to `.vimrc` and
 `.vim` are made in `~`. [Vundle](https://github.com/gmarik/vundle) is
 used to manage plugins.
