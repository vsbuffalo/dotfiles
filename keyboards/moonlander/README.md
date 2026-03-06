# Moonlander Layout

ZSA Moonlander MkI layout source, exported from Oryx.

**Edit in Oryx**: configure.zsa.io/moonlander/layouts/4wNDd/B4EeBW/0

## Files

| File | Purpose |
|------|---------|
| `keymap.json` | Oryx layout (source of truth — re-export from Oryx after changes) |
| `keymap.c` | Generated QMK C source |
| `config.h` | QMK config overrides |
| `rules.mk` | QMK build rules |

## Layers

### Layer 0 — Base

![Layer 0](images/layer-0.jpg)

### Layer 1 — Tmux

Hold thumb key, then: `h/j/k/l` navigate panes · `H/J/K/L` resize panes · `n/p` next/prev window · `|/-` split · `-` split vertical

![Layer 1](images/layer-1.jpg)

### Layer 2 — Media / Mouse

![Layer 2](images/layer-2.jpg)

### Layer 3 — Symbols / F-keys

![Layer 3](images/layer-3.jpg)

## Updating

After changing the layout in Oryx, re-download the source zip and copy the
source files back into this directory:

```bash
cp ~/Downloads/zsa_moonlander_*_source/zsa_moonlander_*_source/{keymap.c,keymap.json,config.h,rules.mk} \
  ~/dotfiles/keyboards/moonlander/
```
