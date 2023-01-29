# NeoVim Configuration

## Installation

    $ brew tap neovim/neovim
    $ brew install --HEAD neovim

We also need to install some Python components,

    $ pip install neovim

and Packer, e.g. with,

    $ sh ../bootloaders/packer.sh

Then in neovim, go to `.config/nvim/lua/vsb/packer.lua` and do

     :so
     :PackerInstall
     :PackerSync

## Updating

    $ brew update
    $ brew reinstall --HEAD neovim



