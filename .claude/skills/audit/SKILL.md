---
name: audit
description: >
  Check neovim plugin health and staleness against a tiered schedule.
  Web-searches GitHub for each due plugin's current status. Use when asked
  about plugin updates, maintenance, or when running periodic audits.
  Also responds to: "are my plugins up to date", "check for updates",
  "plugin health".
context: fork
disable-model-invocation: true
allowed-tools: Bash(git log:*), Bash(cat:*), Bash(jq:*)
argument-hint: "[tool-name] or blank for all"
---

# Plugin Staleness Audit

Check all neovim plugins against their GitHub repos on a tiered schedule.

## Plugin Registry

### Fast-moving (check every 3 months)

| Plugin | Repo |
|--------|------|
| nvim-treesitter | nvim-treesitter/nvim-treesitter |
| nvim-lspconfig | neovim/nvim-lspconfig |
| mason.nvim | mason-org/mason.nvim |
| mason-lspconfig.nvim | mason-org/mason-lspconfig.nvim |
| conform.nvim | stevearc/conform.nvim |
| rustaceanvim | mrcjkb/rustaceanvim |
| telescope.nvim | nvim-telescope/telescope.nvim |
| nvim-cmp | hrsh7th/nvim-cmp |
| copilot.lua | zbirenbaum/copilot.lua |

### Standard (check every 6 months)

| Plugin | Repo |
|--------|------|
| gitsigns.nvim | lewis6991/gitsigns.nvim |
| lualine.nvim | nvim-lualine/lualine.nvim |
| nvim-tree.lua | nvim-tree/nvim-tree.lua |
| nvim-dap | mfussenegger/nvim-dap |
| neotest | nvim-neotest/neotest |
| iron.nvim | Vigemus/iron.nvim |
| LuaSnip | L3MON4D3/LuaSnip |
| yanky.nvim | gbprod/yanky.nvim |
| Comment.nvim | numToStr/Comment.nvim |
| R.nvim | R-nvim/R.nvim |
| ocaml.nvim | tarides/ocaml.nvim |
| nvim-dap-ui | rcarriga/nvim-dap-ui |
| nvim-dap-python | mfussenegger/nvim-dap-python |
| cmp_luasnip | saadparwaiz1/cmp_luasnip |
| cmp-nvim-lsp | hrsh7th/cmp-nvim-lsp |
| copilot-cmp | zbirenbaum/copilot-cmp |
| nvim-web-devicons | nvim-tree/nvim-web-devicons |
| vimtex | lervag/vimtex |
| lazy.nvim | folke/lazy.nvim |
| plenary.nvim | nvim-lua/plenary.nvim |
| nvim-nio | nvim-neotest/nvim-nio |

### Stable/niche (check every 12 months)

| Plugin | Repo |
|--------|------|
| catppuccin | catppuccin/nvim |
| tokyonight.nvim | folke/tokyonight.nvim |
| kanagawa.nvim | rebelot/kanagawa.nvim |
| rose-pine | rose-pine/neovim |
| stan-vim | eigenfoo/stan-vim |
| eidos.vim | vsbuffalo/eidos.vim |
| d2-vim | terrastruct/d2-vim |
| snakemake (vim plugin) | snakemake/snakemake |
| webapi-vim | mattn/webapi-vim |
| mini.align | echasnovski/mini.align |
| FixCursorHold | antoinemadec/FixCursorHold.nvim |

## Procedure

1. **Read lockfile**: Parse `lazy-lock.json` for current pinned commits.

2. **Check memory**: Read `memory/neovim-audit.md` for last audit dates per tier.
   If $ARGUMENTS specifies a tool name, only audit that tier/plugin.

3. **Determine what's due**: Compare last audit dates against cadences above.
   If memory file is missing, everything is due.

4. **For each due plugin**:
   - Web search: `{repo-owner}/{repo-name} github` for current status
   - Check: Is it archived? Deprecated? Has a successor? Any breaking
     changes or major version bumps since the pinned commit?
   - Classify:
     - `✓` current — pinned version is recent, no issues
     - `↑` update available — new release, no breaking changes
     - `⚠` deprecated — maintainer announced deprecation
     - `✗` archived — repo is archived on GitHub
     - `→` successor — a replacement is recommended

5. **Report**: Present a concise table to the user:
   ```
   ## Audit Results — {date}
   | Plugin | Status | Notes |
   |--------|--------|-------|
   | nvim-cmp | ↑ | v0.8.0 released, migration guide available |
   | ... | ... | ... |
   ```

6. **Update memory**: Write date, tiers checked, and per-plugin findings
   to `memory/neovim-audit.md`.

7. **Offer next steps**: If updates are available, offer to:
   - Update `lazy-lock.json` entries
   - Check for breaking changes in updated plugins
   - Run `:Lazy sync` instructions
   Always ask before writing anything.

## Memory File Format

```markdown
# Neovim Plugin Audit Log

## Last Audit
- **Date**: 2025-06-15
- **Tiers checked**: fast-moving, standard

## Findings
| Plugin | Status | Date Checked | Notes |
|--------|--------|-------------|-------|
| nvim-treesitter | ✓ | 2025-06-15 | current |
| ... | ... | ... | ... |

## Recommended Actions
- (any pending actions from last audit)
```
