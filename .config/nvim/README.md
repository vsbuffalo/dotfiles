# Neovim Configuration

Modular Neovim config using lazy.nvim. Leader is `Space`, localleader is `,`.

## Installation

    brew install neovim

Open Neovim and run `:Lazy sync` to install all plugins.

### Fonts

    brew install font-hack-nerd-font

Set your terminal font to Hack Nerd Font.

## Directory Structure

```
~/.config/nvim/
├── init.lua                  # Entry point
├── lua/vinceb/
│   ├── init.lua              # Module loader
│   ├── lazy.lua              # Plugin declarations (lazy.nvim)
│   ├── remap.lua             # Global key mappings
│   ├── set.lua               # Vim options
│   └── filetypes.lua         # Filetype detection
└── after/plugin/             # Plugin-specific configs
    ├── lsp.lua               # LSP servers + completion (nvim-cmp)
    ├── conform.lua           # Formatting (ocamlformat, ruff)
    ├── iron.lua              # REPL integration (iron.nvim)
    ├── dap.lua               # Debug Adapter Protocol
    ├── telescope.lua         # Fuzzy finder
    ├── nvimtree.lua          # File explorer
    ├── copilot.lua           # GitHub Copilot
    ├── colors.lua            # Color schemes
    └── ...
```

### Adding things

- New plugin: `lua/vinceb/lazy.lua`, then `:Lazy sync`
- Plugin config: `after/plugin/<name>.lua`
- Key mappings: `lua/vinceb/remap.lua` (global) or plugin config file (plugin-specific)
- Vim options: `lua/vinceb/set.lua`

## LSP

Configured in `after/plugin/lsp.lua` using Neovim 0.11's native `vim.lsp.config()` API.

| Server | Languages | Notes |
|---|---|---|
| pyright | Python | Auto-detects `.venv` |
| ruff | Python | Linting/formatting, hover disabled (defers to pyright) |
| clangd | C/C++ | |
| texlab | LaTeX | |
| ocamllsp | OCaml | Via `opam exec`, not Mason |
| rust-analyzer | Rust | Managed by rustaceanvim, not configured here |

Mason installs pyright, ruff, clangd, texlab. OCaml LSP is installed via opam (`opam install ocaml-lsp-server`).

### LSP Keybindings

| Key | Action |
|---|---|
| `gd` | Go to definition (via Telescope) |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<C-h>` (insert) | Signature help |
| `<leader>vd` | Diagnostic float |
| `<leader>vca` | Code actions |
| `<leader>vrn` | Rename |
| `<leader>vrr` | References |
| `<leader>vws` | Workspace symbol |
| `]d` / `[d` | Next/prev diagnostic |

### Completion (nvim-cmp)

| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next/prev item |
| `<C-y>` | Confirm (select) |
| `<CR>` | Confirm (no auto-select) |
| `<C-Space>` | Trigger completion |

Sources: Copilot, LSP, LuaSnip, path, buffer.

## Telescope

| Key | Action |
|---|---|
| `<leader>pf` | Find files |
| `<leader>ff` | Git files |
| `<leader>fb` | Buffers |
| `<leader>pa` | Find all files (including ignored) |
| `<leader>tg` | Live grep |
| `<leader>td` | Diagnostics |

## Formatting

Via conform.nvim (`after/plugin/conform.lua`).

| Filetype | Formatter |
|---|---|
| Python | ruff_format, ruff_fix |
| OCaml | ocamlformat |

`<leader>f` to format current buffer.

## OCaml

Three plugins work together:

- **ocamllsp** via native LSP -- type-on-hover, go-to-definition, completions, diagnostics
- **ocaml.nvim** (Tarides) -- Merlin features beyond LSP: typed holes (`:OCamlConstruct`), switch `.ml`/`.mli` (`:OCamlSwitchImplIntf`)
- **conform.nvim** -- format-on-demand with ocamlformat (needs `.ocamlformat` in project root)

Install the toolchain in your opam switch:

    opam install ocaml-lsp-server ocamlformat utop

## REPL (iron.nvim)

Configured in `after/plugin/iron.lua`. Opens a REPL in a vertical split (40% width, right side).

| Filetype | REPL command |
|---|---|
| OCaml | `dune utop` |
| Python | `python3` |
| sh | `zsh` |

### REPL Keybindings

| Key | Action |
|---|---|
| `<leader>rr` | Toggle REPL |
| `<leader>rR` | Restart REPL |
| `<leader>sc` | Send motion / visual selection |
| `<leader>sl` | Send line |
| `<leader>sp` | Send paragraph |
| `<leader>sf` | Send file |
| `<leader>su` | Send until cursor |
| `<leader>s<CR>` | Send carriage return (e.g. `;;` for utop) |
| `<leader>s<Space>` | Interrupt (Ctrl-C) |

## Debugging (DAP)

Python debugging via nvim-dap + dap-python + dap-ui. Install `debugpy` in your venv.

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Open REPL |
| `<leader>dl` | Run last config |
| `<leader>du` | Toggle DAP UI |
| `<leader>dx` | Terminate |
| `<leader>de` | Evaluate expression under cursor |

## General Keybindings

### Files and Buffers

| Key | Action |
|---|---|
| `<leader>w` | Save |
| `<leader>q` | Quit |
| `<leader>x` | Close window |
| `<leader>bd` | Close buffer (keep window) |
| `<leader>l` | Vertical split |
| `<C-j>` / `<C-k>` | Prev/next buffer |
| `<leader>pv` | File explorer (netrw) |
| `<leader>f` | Format buffer (conform) |

### Navigation

| Key | Action |
|---|---|
| `<A-h/j/k/l>` | Move between splits |
| `<C-d>` / `<C-u>` | Scroll down/up (centered) |
| `<leader><Esc>` | Exit terminal mode |

### Editing

| Key | Action |
|---|---|
| `J` / `K` (visual) | Move text block down/up |
| `J` (normal) | Join lines (cursor stays) |
| `<leader><Space>` | Format paragraph (gwip) |
| `<leader>y` | Yank to system clipboard |
| `<leader>Y` | Yank line to system clipboard |
| `<leader>h` | Clear search highlight |
| `ga` / `gA` | Align (mini.align) |
| `gc` | Comment toggle (Comment.nvim) |

### Config Shortcuts

| Key | Action |
|---|---|
| `<leader>se` | Edit lazy.lua |
| `<leader>ss` | `:Lazy sync` |
| `<leader>re` | Edit remap.lua |
| `<leader>pe` | Browse after/plugin/ |
| `<leader>pp` | Reload init.lua |
| `<leader>c` | Cycle colorscheme |
| `<leader>ce` | Edit colors config |

### Rust

| Key | Action |
|---|---|
| `<C-d>` (insert) | Insert `{:?}` |
| `<leader>gt` | Go to tests |
| `<leader>n` | Add `.unwrap()` before `;` |

### Git

| Key | Action |
|---|---|
| `<leader>bb` | Toggle inline git blame |

## Plugins

Managed by lazy.nvim. Full list in `lua/vinceb/lazy.lua`.

| Plugin | Purpose |
|---|---|
| nvim-lspconfig | LSP client configuration |
| mason.nvim | LSP server installer |
| nvim-cmp | Autocompletion |
| copilot.lua + copilot-cmp | GitHub Copilot |
| telescope.nvim | Fuzzy finder |
| nvim-treesitter | Syntax highlighting |
| conform.nvim | Formatting |
| iron.nvim | REPL integration |
| ocaml.nvim | OCaml Merlin features |
| rustaceanvim | Rust tooling |
| nvim-dap + dap-ui | Debugging |
| neotest | Test runner |
| nvim-tree.lua | File explorer |
| gitsigns.nvim | Git signs + inline blame |
| Comment.nvim | Comment toggling |
| mini.align | Text alignment |
| yanky.nvim | Yank history |
| lualine.nvim | Statusline |
| vimtex | LaTeX |
| R.nvim | R language |
| LuaSnip | Snippets |
