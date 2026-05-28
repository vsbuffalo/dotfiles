# Neovim Keybinding Reference

**Leader**: `Space`
**Local leader**: `,` (used by R.nvim)

> Tip: Use `:nmap <space>q` to check what any mapping does.

## General

| Key | Mode | Action |
|-----|------|--------|
| `<leader>w` | n | Save file |
| `<leader>q` | n | Quit |
| `<leader>x` | n | Close window |
| `<leader>bd` | n | Close buffer (keep window) |
| `<leader>l` | n | Vertical split |
| `<leader>pv` | n | Open netrw (file explorer) |
| `<leader>h` | n | Clear search highlight |
| `<leader><space>` | n | Reformat paragraph (`gwip`) |
| `<leader>y` | n/v | Yank to system clipboard |
| `<leader>Y` | n | Yank line to system clipboard |

## Navigation

| Key | Mode | Action |
|-----|------|--------|
| `C-j` | n | Previous buffer |
| `C-k` | n | Next buffer |
| `Alt-h/j/k/l` | n | Move between splits |
| `C-d` | n | Half-page down (centered) |
| `C-u` | n | Half-page up (centered) |
| `J` / `K` | v | Move selected lines down / up |

## Telescope (Fuzzy Finder)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pf` | n | Find files |
| `<leader>ff` | n | Git files |
| `<leader>fb` | n | Buffers |
| `<leader>pa` | n | Find all files (including ignored) |
| `<leader>tg` | n | Live grep |
| `<leader>td` | n | Diagnostics |

## LSP

Available in buffers with an active language server.

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition (via Telescope) |
| `gD` | n | Go to declaration |
| `gi` | n | Go to implementation |
| `K` | n | Hover docs |
| `C-h` | i | Signature help |
| `<leader>vd` | n | Show diagnostic float |
| `<leader>vca` | n | Code action |
| `<leader>vrr` | n | References |
| `<leader>vrn` | n | Rename symbol |
| `<leader>vws` | n | Workspace symbol search |
| `[d` / `]d` | n | Next / prev diagnostic |

## Completions (nvim-cmp)

| Key | Mode | Action |
|-----|------|--------|
| `C-n` | i | Next completion item |
| `C-p` | i | Previous completion item |
| `C-y` | i | Confirm completion |
| `Enter` | i | Confirm completion (must select first) |
| `C-Space` | i | Trigger completion |

Sources (in priority order): Copilot, LSP, LuaSnip, path, buffer.

## File Tree (NvimTree)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>e` | n | Toggle file tree |
| `<leader>r` | n | Refresh file tree |
| `<leader>f` | n | Reveal current file in tree |

## Git (Fugitive)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gs` | n | Open Git status |

## Testing (Neotest / pytest)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tt` | n | Run nearest test |
| `<leader>tf` | n | Run tests in current file |
| `<leader>td` | n | Debug nearest test (DAP) |
| `<leader>ts` | n | Toggle test summary panel |
| `<leader>to` | n | Show test output |
| `<leader>tl` | n | Rerun last test |

## Debugging (DAP)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dc` | n | Start / continue debugging |
| `<leader>db` | n | Toggle breakpoint |
| `<leader>dB` | n | Set conditional breakpoint |
| `<leader>di` | n | Step into |
| `<leader>do` | n | Step over |
| `<leader>dO` | n | Step out |
| `<leader>dr` | n | Open REPL |
| `<leader>dl` | n | Rerun last debug config |
| `<leader>du` | n | Toggle DAP UI |
| `<leader>dx` | n | Terminate debug session |
| `<leader>de` | n/v | Evaluate expression under cursor |

## R (R.nvim)

Local leader is `,` for all R.nvim commands. These work in `.R` and `.Rmd` files.

### Starting / Stopping

| Key | Mode | Action |
|-----|------|--------|
| `,rf` | n | Start R console |
| `,rq` | n | Quit R |

### Sending Code

| Key | Mode | Action |
|-----|------|--------|
| `Enter` | n | Send current line (custom) |
| `Enter` | v | Send selection (custom) |
| `,l` | n | Send line (R.nvim default) |
| `,pp` | n | Send paragraph (between blank lines) |
| `,bb` | n | Send block (between `# %%` marks) |
| `,cc` | n | Send chunk (Rmd fenced chunk) |
| `,aa` | n | Send entire file |

To use `,bb`, add `# %%` comment markers to delimit code sections:

```r
# %%
x <- 1:10
y <- rnorm(10)
model <- lm(y ~ x)
# %%
```

For sending an arbitrary block without markers, use visual select:
`V` (enter visual line mode) -> select lines -> `Enter`

### Help & Objects

| Key | Mode | Action |
|-----|------|--------|
| `,rh` | n | Help on word under cursor |
| `,re` | n | Show examples |
| `,rs` | n | Object structure (`str()`) |
| `,rp` | n | Print object |

## Config Quick Access

| Key | Mode | Action |
|-----|------|--------|
| `<leader>se` | n | Edit plugin list (`lazy.lua`) |
| `<leader>ss` | n | Run `:Lazy sync` |
| `<leader>re` | n | Edit keybindings (`remap.lua`) |
| `<leader>pe` | n | Browse plugin configs (`after/plugin/`) |
| `<leader>pp` | n | Reload `init.lua` |
| `<leader>ce` | n | Edit colorscheme config |
| `<leader>c` | n | Cycle colorscheme |

## Rust Shortcuts

| Key | Mode | Action |
|-----|------|--------|
| `C-d` | i | Insert `{:?}` (debug format) |
| `<leader>gt` | n | Jump to `#[cfg(test)]` module |
| `<leader>n` | n | Add `.unwrap()` before semicolon |

## Terminal

Open a terminal with `:terminal`, `:split | terminal`, or `:vsplit | terminal`.

| Key | Mode | Action |
|-----|------|--------|
| `<leader><Esc>` | t | Exit terminal mode to normal mode |

## Insert Mode Extras

| Key | Mode | Action |
|-----|------|--------|
| `Alt-b` | i | Move back one word |
| `Alt-f` | i | Move forward one word |
| `Esc-Backspace` | i | Delete word backward |
