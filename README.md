## Dotfiles2

Removing the cruft from my first dotfiles. Out with the old, in with the new!

⚠️**Warning**: If you use my `dotfiles2`, you *must* modify this to your own
purposes! For example, `.gitconfig` contains my Git configurations, including
my email, etc. Simply cloning this repository and running the setup will result
in your Git commits being made under *my* name and email, and neither of us
want that.

## Installation

This will bootstrap things:

    bash setup.sh

Note that if you have an existing `~/.config/` directory, it will not be
overwritten. However, this will mean none of the configurations in `dotfiles2`
will be linked, so it is generally advised you remove or merge in the existing
`.config/` after running `setup.sh`.

For NeoVim-specific setup instructions, see the [NeoVim
configuration](https://github.com/vsbuffalo/dotfiles2/tree/main/.config/nvim)
documentation.

To have Apple's Keychain manage your SSH key's password, do the following:

```
$ ssh-add --apple-use-keychain ~/.ssh/[your-private-key]
```

## Configurations

 - `.zsh`: antidote for plugins.

## Caveats

So far only tested on OS X.


