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

## 🪑 Ergonomic Desk Setup – Personal Reference

I have the following sit-stand desk, which I love: [Duo Standing
Desk](https://www.branchfurniture.com/products/duo-standing-desk?) (Walnut,
Sage legs), desk Size: 36 inches x 24 inches. After some initial configuration
and chatting with ChatGPT, these are the settings I have arrived at.

### 📏 Key Measurements

Guesstimates base don 

- **Height**: 6'1.5" (187 cm)
- **Seated Elbow Height**: `27.8"` → Ideal seated desk height
- **Standing Elbow Height**: `44.1"` → Ideal standing desk height
- **Chair Height**: ~20" from floor (measured when seated)

### ✅ Desk Height Guidelines

- **Sitting Mode**: Set desk to ~`28.2"` (±0.5")  
  Ensure feet are supported (meditation cushion works well). Knees and elbows at 90°, shoulders relaxed.

- **Standing Mode**: Set desk to ~`44.1"` (or slightly higher if looking down too much)  
  Use a footrest or bar to shift weight occasionally. Monitor should be slightly above eye level, especially for terminal-heavy work.

### 🖥️ Monitor Ergonomics

- Raise monitor so that the **center is ~2–3" above eye level**
- Slight backward tilt (~10–15°) helps reduce neck strain
- For terminal-heavy or code workflows, prioritize visibility in the top ⅓ of the screen

## Caveats

So far only tested on OS X.



