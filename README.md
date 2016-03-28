# dotfiles

Clone to your `~` directory and use the following to install:

    $ sh setup.sh

My dotfiles install process does the following (if these files/programs don't
exist):

 - Installs Git, NeoVim, Ag, and tmux (from Homebrew, since these are dependencies)
 - Installs [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
 - Installs [Futurama quotes](https://github.com/vsbuffalo/good-news-everyone)
 - Installs `~/.zshrc`
 - Links `~/.gitconfig`
 - Links `~/.tmux.conf`
 - Creates `~/.global_ignore` from Github's `.gitignore` files and sets up Git colors
 - Links `~/.Rprofile` and installs some R packages
 - Stores and links NeoVim's files (see below).

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

## NeoVim

Annoyed with Emacs running evil-mode (and clashing with packages like polyweb),
I decided to try [NeoVim](http://neovim.io/). I'm happy to report that it's
terrific, and likely my permanent text editor. Using the
[vim-rsi](https://github.com/tpope/vim-rsi) plugin, I can use emacs mappings in
insert mode (this is a big deal). There's also great support for Ag, Git
through fugitive, really terrific Python, C/C++ completion through the
unbeatable [YouCompleteMe](https://github.com/Valloric/YouCompleteMe), and some
hacky vimscript I wrote to send lines of code to the new, awesom NeoVim
terminal. You can see all of my configurations in `.nvim*`. I will keep my old
Vim configurations around too.
