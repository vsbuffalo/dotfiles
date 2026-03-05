# Neovim Plugin Audit Log

## Last Audit
- **Date**: 2026-03-03
- **Tiers checked**: fast-moving, standard, stable/niche

## Findings
| Plugin | Tier | Status | Date Checked | Pinned SHA (short) | Notes |
|--------|------|--------|--------------|--------------------|-------|
| nvim-treesitter | fast | ⚠ | 2026-03-03 | 42fc28b | master branch archived; full rewrite on main branch (incompatible) |
| nvim-lspconfig | fast | ✓ | 2026-03-03 | ead0f5f | current (pinned = latest on master, 2026-02-27) |
| mason.nvim | fast | ✓ | 2026-03-03 | 44d1e90 | current (pinned = latest on main, v2.2.1, 2026-01-07) |
| mason-lspconfig.nvim | fast | ✓ | 2026-03-03 | a324581 | current (pinned = latest on main, 2026-02-28) |
| conform.nvim | fast | ✓ | 2026-03-03 | 40dcec5 | current (pinned = latest on master, 2026-03-01) |
| rustaceanvim | fast | ↑ | 2026-03-03 | e9c5aab | v8.0.3 released (2026-02-25), latest sha d50597d; breaking: requires nvim>=0.10 |
| telescope.nvim | fast | ↑ | 2026-03-03 | a0bbec2 | pinned to 0.1.x (last commit 2024-05-24); master now more stable, README recommends switching |
| nvim-cmp | fast | ✓ | 2026-03-03 | da88697 | current (pinned = latest on main, 2026-01-23); blink.cmp is popular alternative but nvim-cmp not deprecated |
| copilot.lua | fast | ↑ | 2026-03-03 | 00446a6 | behind master; latest 3061c49 (2026-03-03) with Copilot LSP updates |
| gitsigns.nvim | standard | ✓ | 2026-03-03 | 9f3c6dd | current (pinned = latest on main, 2026-02-13) |
| lualine.nvim | standard | ✓ | 2026-03-03 | 47f91c4 | current (pinned = latest on master, 2025-11-23) |
| nvim-tree.lua | standard | ↑ | 2026-03-03 | c988e28 | behind master; latest c8d8d51 (2026-03-04) |
| nvim-dap | standard | ✓ | 2026-03-03 | b516f20 | current (pinned = latest on master, 2026-02-26) |
| neotest | standard | ✓ | 2026-03-03 | deadfb1 | current (pinned = latest on master, 2025-11-08) |
| iron.nvim | standard | ✓ | 2026-03-03 | 88cd340 | current (pinned = latest on master, 2026-02-20) |
| LuaSnip | standard | ✓ | 2026-03-03 | dae4f5a | current (pinned = latest on master, 2026-01-19) |
| yanky.nvim | standard | ✓ | 2026-03-03 | 9d3caea | current (pinned = latest on main, 2026-02-09) |
| Comment.nvim | standard | ⚠ | 2026-03-03 | e30b7f2 | last commit 2024-06-09; neovim 0.10+ has native commenting — plugin likely redundant |
| R.nvim | standard | ✓ | 2026-03-03 | 6004610 | current (pinned = latest on main, 2026-03-02) |
| ocaml.nvim | standard | ✓ | 2026-03-03 | f13728b | current (pinned = latest on main, 2025-12-02) |
| nvim-dap-ui | standard | ✓ | 2026-03-03 | cf91d5e | current (pinned = latest on master, 2025-07-09) |
| nvim-dap-python | standard | ✓ | 2026-03-03 | 1808458 | current (pinned = latest on master, 2025-12-20) |
| cmp_luasnip | standard | ✓ | 2026-03-03 | 98d9cb5 | current (pinned = latest on master, 2024-11-04); low activity |
| cmp-nvim-lsp | standard | ✓ | 2026-03-03 | cbc7b02 | current (pinned = latest on main, 2025-11-13) |
| copilot-cmp | standard | ✓ | 2026-03-03 | 15fc12a | current (pinned = latest on master, 2024-12-11); low activity |
| nvim-web-devicons | standard | ✓ | 2026-03-03 | 737cf6c | current (pinned = latest on master, 2026-02-25) |
| vimtex | standard | ✓ | 2026-03-03 | fcd1533 | current (pinned = latest on master, 2026-02-28) |
| lazy.nvim | standard | ✓ | 2026-03-03 | 306a055 | current (pinned = latest on main, 2025-12-17) |
| plenary.nvim | standard | ✓ | 2026-03-03 | b9fd522 | current (pinned = latest on master, 2025-07-26) |
| nvim-nio | standard | ✓ | 2026-03-03 | 21f5324 | current (pinned = latest on master, 2025-01-20) |
| catppuccin | stable | ✓ | 2026-03-03 | 0a5de4d | current (pinned = latest on main, 2026-02-15) |
| tokyonight.nvim | stable | ✓ | 2026-03-03 | 5da1b76 | current (pinned = latest on main, 2025-11-05) |
| kanagawa.nvim | stable | ✓ | 2026-03-03 | aef7f5c | current (pinned = latest on master, 2025-10-15) |
| rose-pine | stable | ✓ | 2026-03-03 | cf2a288 | current (pinned = latest on main, 2025-11-12) |
| stan-vim | stable | ✓ | 2026-03-03 | d14f7f5 | current (pinned = latest on master, 2023-12-13); niche, low activity expected |
| eidos.vim | stable | ✓ | 2026-03-03 | ec2d0a9 | current (pinned = latest on master, 2020-04-10); personal plugin |
| d2-vim | stable | ✓ | 2026-03-03 | cb3eb7f | current (pinned = latest on master, 2025-08-19) |
| snakemake | stable | ✓ | 2026-03-03 | b88171c | current; official snakemake repo includes vim support |
| webapi-vim | stable | ✓ | 2026-03-03 | 70c49ad | current (pinned = latest on master, 2022-11-23); stable/dormant |
| mini.align | stable | ✓ | 2026-03-03 | 60c61c8 | current (pinned = latest on stable, 2025-11-03) |
| FixCursorHold | stable | ⚠ | 2026-03-03 | 1900f89 | unnecessary since neovim 0.8+; CursorHold bug fixed upstream; last commit 2023-02-13 |

## Recommended Actions
- **nvim-treesitter**: CRITICAL — master branch is archived. Either migrate config to new `main` branch (incompatible rewrite, requires manual feature activation) or explicitly pin to `master` to stay on legacy. See: https://github.com/nvim-treesitter/nvim-treesitter/discussions/7901
- **telescope.nvim**: Consider switching from `0.1.x` to `master` branch. The 0.1.x branch hasn't been updated since May 2024. Master is now recommended. See: https://github.com/nvim-telescope/telescope.nvim/issues/3524
- **rustaceanvim**: Update to v8.0.3 (sha d50597d). Requires nvim>=0.10. Check `tools.rustc.edition` config (deprecated in favor of `tools.rustc.default_edition`).
- **copilot.lua**: Update available (latest 3061c49, 2026-03-03). Contains Copilot LSP updates.
- **nvim-tree.lua**: Minor update available (latest c8d8d51, 2026-03-04). Performance improvement for tree updates.
- **Comment.nvim**: Consider removing — Neovim 0.10+ has native commenting (`gc`/`gcc`). Plugin hasn't been updated since June 2024.
- **FixCursorHold.nvim**: Consider removing — the CursorHold performance bug was fixed in Neovim 0.8. Plugin is unnecessary on any modern Neovim.
