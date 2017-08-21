# iPython configurations

These need to manually linked -- still need to write an installation bash
script. Use something like:

For `custom.js`, which hides the toolbars in jupyter notebooks.

    $ ln -s ~/dotfiles/ipython-profile-default/custom.js ~/.ipython/profile_default/static/custom/

For my default ipython profile:

    $ ln -s ~/dotfiles/ipython-profile-default/ipython_config.py ~/.ipython/profile_default/ipython_config.py


## Notebook extensions

    $ pip3 install jupyter_contrib_nbextensions
    $ jupyter contrib nbextension install --user

## QT Console

    $ pip3 install PyQt5


