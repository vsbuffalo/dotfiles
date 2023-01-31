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

## Lua Line and Fonts

You may need nerdfonts,

    $ brew tap homebrew/cask-fonts
    $ brew install font-hack-nerd-font

and then if in iTerm2, go to Preferences (`⌘,`), 
Profiles, Text, and choose `Hack nerd font` 
from the drop down fonts menu. I'd also increase 
the font size.

## VimTex

VimTex requires MacTex and Skim. Download
MacTeX from [their website](https://www.tug.org/mactex/mactex-download.html) 
and install Skim with

    $ brew install --cask skim

or from their website.

