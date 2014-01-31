# Vim Configuration

## Installing MacVim

    brew install vim
    brew install macvim --env-std --override-system-vim

## Installing Vim Plugin Prerequisites

These must be manually installed. First, is
[powerline](https://github.com/Lokaltog/powerline)
([documentation](https://powerline.readthedocs.org/)) and its patched set of
[fonts](https://github.com/Lokaltog/powerline-fonts/tree/master/DejaVuSansMono)
(I use DejaVuSansMono). Powerline is tricky to install; the way that worked for
me was to use `pip` and manually link to its files in my `.vimrc`:

    pip install git+git://github.com/Lokaltog/powerline

Fonts can be downloaded and installed via the Finder.

