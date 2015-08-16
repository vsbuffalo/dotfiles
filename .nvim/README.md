# NeoVim Configuration

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

## Setup Notes

[Ultisnips](https://github.com/SirVer/ultisnips) provides code snippets, with
[vim-snippets](https://github.com/honza/vim-snippets) providing the actual code
snippets for different languages.


