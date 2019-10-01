# NeoVim Configuration

## Requirements

You'll need to have the [Powerline fonts](https://github.com/powerline/fonts)
for some of the pretty icons in the lightline plugin to display correctly.

## Installation

    $ brew tap neovim/neovim
    $ brew install --HEAD neovim

We also need to install some Python components:

    $ pip install neovim

## Updating

    $ brew update
    $ brew reinstall --HEAD neovim

## Installing Vim-Plug

Rather than using Bundle/Vundle, I'm trying
[vim-plug](https://github.com/junegunn/vim-plug):

    $ curl -fLo ~/.nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

## Compiling YouCompleteMe

After installing YouCompleteMe you'll need to compile it
with:

    $ cd ~/.nvim/plugged/YouCompleteMe
    $ ./install.py --clang-completer

Note that there are all sorts of issues  with conda and YCM, so be sure to run 

    source deactivate

before the above.

## Intalling TernJs

    $ cd ~/.nvim/plugged/tern_for_vim
    $ node install

## Setup Notes

[Ultisnips](https://github.com/SirVer/ultisnips) provides code snippets, with
[vim-snippets](https://github.com/honza/vim-snippets) providing the actual code
snippets for different languages.


