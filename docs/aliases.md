# Shell Aliases & Functions

Quick reference for everything defined in `.zshrc`.

## Navigation

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `cdp <dir>` | `cd ~/projects/personal/<dir>` | |
| `cdw <dir>` | `cd ~/projects/work/<dir>` | |
| `cdnv` | `cd ~/.config/nvim/` | |
| `y` | yazi with cwd tracking | `cd`s to wherever you exit yazi |

## File Listing (eza)

| Alias | What |
|-------|------|
| `ll` | long listing, icons, sorted by date |
| `la` | same + hidden files |
| `ld` | `ll` on `~/Downloads` |
| `ct` | tree view, respects `.gitignore`, filters build artifacts |

## Editors & Tools

| Alias | Expands to |
|-------|-----------|
| `nv` | `nvim` |
| `vim` | `nvim` (auto-aliased if nvim exists) |
| `less` | `bat` |
| `g` | `git` |
| `h` | `brew` |
| `gl` | `git pull --rebase` |

## Utility

| Alias | What |
|-------|------|
| `sz` | `source ~/.zshrc` (reload) |
| `oo` | `open .` (Finder) |
| `today` | print `YYYY-MM-DD` |
| `now` | print ISO 8601 UTC timestamp |
| `weather` | `curl wttr.in/Seattle?u` |
| `darkmode` | toggle macOS dark/light mode |
| `mdfmt` | `dprint fmt --config-discovery=global` |
| `git-whoami` | show git email + config source for current repo |

## File Openers

| Function | What |
|----------|------|
| `excel <file>` | open csv/xlsx in Microsoft Excel |
| `app <url>` | open URL as Chrome app window |
