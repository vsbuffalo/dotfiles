---
name: commands
description: >
  Full command reference for keybindings, aliases, shell commands, and
  tool usage. Use when the user asks "how do I...", "what's the shortcut
  for...", "what key does...", or references a command they can't remember.
  Also use when the user discovers a new command and wants to save it.
  Covers: neovim, tmux, zsh, git, cargo, opam, dune, uv.
argument-hint: "<topic>"
---

# Command Reference (Tier 2)

This is the full reference. Tier 1 (compact) lives in root CLAUDE.md and
is always in context. This skill adds: modes, source file locations, notes
about conflicts, and tool-specific sections.

## Routing

If `$ARGUMENTS` is provided, jump to the matching section. Topics:
`neovim`, `lsp`, `completion`, `telescope`, `testing`, `debug`, `repl`,
`git`, `editing`, `latex`, `r`, `config`, `tmux`, `zsh`, `gitcli`,
`cargo`, `opam-dune`, `uv`

If no argument, ask what the user is looking for.

After answering, check if this was a new discovery. If the user learned
something they didn't know, append it to `memory/command-notes.md` with
today's date.

---

## Neovim — General

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<Space>` | Leader | n | `set.lua` |
| `,` | Local leader | n | `set.lua` |
| `<leader>e` | Toggle nvim-tree | n | `after/plugin/nvim-tree.lua` |
| `J` (visual) | Move selection down | v | `remap.lua` |
| `K` (visual) | Move selection up | v | `remap.lua` |
| `<leader>w` | Save file | n | `remap.lua` |
| `<leader>q` | Quit | n | `remap.lua` |
| `<leader>bd` | Close buffer (preserve window) | n | `remap.lua` |
| `<C-j>` / `<C-k>` | Prev / next buffer | n | `remap.lua` |
| `<leader>l` | Vertical split | n | `remap.lua` |
| `<A-h/j/k/l>` | Navigate splits | n | `remap.lua` |
| `<leader>h` | Clear search highlight | n | `remap.lua` |
| `<leader><space>` | Rewrap paragraph | n | `remap.lua` |
| `<leader>y` | Yank to system clipboard | n,v | `remap.lua` |
| `<leader>Y` | Yank line to system clipboard | n | `remap.lua` |
| `<C-d>` | Half-page down + center | n | `remap.lua` |
| `<C-u>` | Half-page up + center | n | `remap.lua` |

## Neovim — LSP

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `gd` | Go to definition | n | `after/plugin/lsp.lua` |
| `gD` | Go to declaration | n | `after/plugin/lsp.lua` |
| `gi` | Go to implementation | n | `after/plugin/lsp.lua` |
| `<leader>vrr` | Go to references | n | `after/plugin/lsp.lua` |
| `K` | Hover documentation | n | `after/plugin/lsp.lua` |
| `<leader>vrn` | Rename symbol | n | `after/plugin/lsp.lua` |
| `<leader>vca` | Code actions | n | `after/plugin/lsp.lua` |
| `<leader>vd` | Diagnostic float | n | `after/plugin/lsp.lua` |
| `]d` | Next diagnostic | n | `after/plugin/lsp.lua` |
| `[d` | Prev diagnostic | n | `after/plugin/lsp.lua` |
| `<leader>vws` | Workspace symbol search | n | `after/plugin/lsp.lua` |
| `<C-h>` | Signature help | i | `after/plugin/lsp.lua` |

## Neovim — Completion (nvim-cmp)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<C-n>` | Next item | i | `after/plugin/lsp.lua` |
| `<C-p>` | Prev item | i | `after/plugin/lsp.lua` |
| `<C-y>` | Confirm selection | i | `after/plugin/lsp.lua` |
| `<CR>` | Confirm (no auto-select) | i | `after/plugin/lsp.lua` |
| `<C-Space>` | Trigger completion | i | `after/plugin/lsp.lua` |

## Neovim — Telescope

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>pf` | Find files | n | `after/plugin/telescope.lua` |
| `<leader>ff` | Find git files | n | `after/plugin/telescope.lua` |
| `<leader>pa` | Find all files (incl. ignored) | n | `after/plugin/telescope.lua` |
| `<leader>tg` | Live grep | n | `after/plugin/telescope.lua` |
| `<leader>fb` | Buffers | n | `after/plugin/telescope.lua` |
| `<leader>td` | Diagnostics | n | `after/plugin/telescope.lua` |

## Neovim — Testing (neotest)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>tt` | Run nearest test | n | `after/plugin/neotest.lua` |
| `<leader>tf` | Run file tests | n | `after/plugin/neotest.lua` |
| `<leader>ts` | Toggle test summary | n | `after/plugin/neotest.lua` |
| `<leader>to` | Show test output | n | `after/plugin/neotest.lua` |
| `<leader>tl` | Run last test | n | `after/plugin/neotest.lua` |
| `<leader>td` | Debug nearest test (DAP) | n | `after/plugin/neotest.lua` |

## Neovim — Debug (nvim-dap)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>db` | Toggle breakpoint | n | `after/plugin/dap.lua` |
| `<leader>dc` | Continue / start | n | `after/plugin/dap.lua` |
| `<leader>do` | Step over | n | `after/plugin/dap.lua` |
| `<leader>di` | Step into | n | `after/plugin/dap.lua` |
| `<leader>dO` | Step out | n | `after/plugin/dap.lua` |
| `<leader>dr` | Open REPL | n | `after/plugin/dap.lua` |
| `<leader>dl` | Run last debug config | n | `after/plugin/dap.lua` |
| `<leader>du` | Toggle DAP UI | n | `after/plugin/dap.lua` |
| `<leader>dx` | Terminate debug session | n | `after/plugin/dap.lua` |
| `<leader>dB` | Set conditional breakpoint | n | `after/plugin/dap.lua` |
| `<leader>de` | Evaluate expression | n,v | `after/plugin/dap.lua` |

## Neovim — REPL (iron.nvim)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>sc` | Send motion to REPL | n | `after/plugin/iron.lua` |
| `<leader>sc` | Send visual selection | v | `after/plugin/iron.lua` |
| `<leader>sf` | Send file to REPL | n | `after/plugin/iron.lua` |
| `<leader>sl` | Send line to REPL | n | `after/plugin/iron.lua` |
| `<leader>sp` | Send paragraph | n | `after/plugin/iron.lua` |
| `<leader>su` | Send until cursor | n | `after/plugin/iron.lua` |
| `<leader>s<CR>` | Send CR to REPL | n | `after/plugin/iron.lua` |
| `<leader>s<space>` | Interrupt REPL | n | `after/plugin/iron.lua` |
| `<leader>rr` | Toggle REPL | n | `after/plugin/iron.lua` |
| `<leader>rR` | Restart REPL | n | `after/plugin/iron.lua` |

## Neovim — Git

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>gs` | Git status (fugitive) | n | `after/plugin/fugitive.lua` |
| `<leader>bb` | Toggle blame | n | `lua/vinceb/lazy.lua` (gitsigns config) |

## Neovim — Editing

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `gc` | Comment (toggle, motion) | n,v | Comment.nvim |
| `gcc` | Comment line | n | Comment.nvim |
| `<leader>f` | Format buffer | n | `after/plugin/conform.lua` |
| `ga` | Align (motion) | n,v | mini.align |
| `p` | Put with yanky (cycles) | n | `after/plugin/yanky.lua` |
| `<C-n>` | Cycle yanky forward | n | `after/plugin/yanky.lua` |
| `<C-p>` | Cycle yanky backward | n | `after/plugin/yanky.lua` |

## Neovim — LaTeX (vimtex)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<localleader>ll` | Compile (continuous) | n | vimtex |
| `<localleader>lv` | View PDF | n | vimtex |
| `<localleader>lc` | Clean aux files | n | vimtex |
| `<localleader>lt` | Table of contents | n | vimtex |

## Neovim — R (R.nvim)

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<localleader>rf` | Start R | n | R.nvim |
| `<localleader>rq` | Quit R | n | R.nvim |
| `<localleader>l` | Send line | n | R.nvim |
| `<localleader>ss` | Send selection | v | R.nvim |
| `<localleader>ff` | Send file | n | R.nvim |

## Neovim — Config Shortcuts

| Key | Action | Mode | Source |
|-----|--------|------|--------|
| `<leader>se` | Edit lazy.lua | n | `remap.lua` |
| `<leader>re` | Edit remap.lua | n | `remap.lua` |
| `<leader>pe` | Browse after/plugin/ | n | `remap.lua` |

## Tmux

Prefix: `C-b`

| Key | Action |
|-----|--------|
| `C-b c` | New window |
| `C-b [0-9]` | Switch to window N |
| `C-b n` / `C-b p` | Next / prev window |
| `C-b |` | Split horizontal |
| `C-b -` | Split vertical |
| `C-b [` | Enter copy mode (vi keys) |
| `C-b ]` | Paste from buffer |
| `C-b d` | Detach |
| `C-b z` | Toggle pane zoom |
| `C-b ,` | Rename window |
| `C-b &` | Kill window |
| `C-b C-a` | Last window |
| `C-b b` | Toggle status bar |
| `C-b r` | Reload config |

## Zsh

| Command / Alias | Action |
|----------------|--------|
| `less` | `bat` pager |
| `la` | `eza -la --icons --sort date` |
| `ll` | `eza -l --icons --sort date` |
| `ld` | `eza -l --icons --sort date ~/Downloads` |
| `ct` | `eza --tree` (git-aware, filtered) |
| `sz` | `source ~/.zshrc` |
| `oo` | `open .` |
| `nv` / `vim` | `nvim` |
| `g` | `git` |
| `gl` | `git pull --rebase` |
| `h` | `brew` |
| `y` | yazi file manager (cd on exit) |
| `cdp <dir>` | `cd ~/projects/personal/<dir>` |
| `cdw <dir>` | `cd ~/projects/work/<dir>` |
| `cdnv` | `cd ~/.config/nvim/` |
| `mdfmt` | `dprint fmt --config-discovery=global` |
| `darkmode` | Toggle macOS dark/light mode |
| `today` | Print current date (YYYY-MM-DD) |
| `now` | Print UTC timestamp |
| `weather` | `curl wttr.in/Seattle` |
| `git-whoami` | Show git identity for current repo |

## Git CLI

| Command | Action |
|---------|--------|
| `git log --oneline --graph` | Compact log with graph |
| `git diff --staged` | Diff staged changes |
| `git stash -u` | Stash including untracked |
| `git rebase -i HEAD~N` | Interactive rebase last N |
| `git reflog` | Recovery: find lost commits |
| Check `.gitconfig` for aliases — `delta` is the pager. |

## Cargo

| Command | Action |
|---------|--------|
| `cargo build` | Build (debug) |
| `cargo build --release` | Build (optimized) |
| `cargo test` | Run tests |
| `cargo clippy` | Lint |
| `cargo fmt` | Format |
| `cargo doc --open` | Build and open docs |
| `cargo add <crate>` | Add dependency |

## opam / dune

| Command | Action |
|---------|--------|
| `opam switch list` | List switches |
| `opam switch create . --deps` | Project-local switch |
| `opam install . --deps-only` | Install project deps |
| `dune build` | Build |
| `dune test` | Run tests |
| `dune exec <binary>` | Run binary |
| `dune utop` | Launch utop with project |
| `dune fmt` | Format (ocamlformat) |

## uv (Python)

| Command | Action |
|---------|--------|
| `uv sync` | Install from lockfile |
| `uv add <pkg>` | Add dependency |
| `uv run <script>` | Run with project env |
| `uv venv` | Create venv |
| `uv pip install` | Install (pip compat) |
| `uv tool run <tool>` | Run tool without install |
