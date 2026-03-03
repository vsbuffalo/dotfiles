# Neovim Plugin Audit Log

## Last Audit
- **Date**: 2026-03-02
- **Tiers checked**: fast-moving, standard, stable/niche
- **Neovim version**: 0.11.2

## Findings

### Fast-moving tier

| Plugin | Status | Date Checked | Notes |
|--------|--------|-------------|-------|
| nvim-treesitter | ⚠ | 2026-03-02 | master branch archived (commit 42fc28b is the archival announcement). Full incompatible rewrite on `main` branch. Migration required. |
| nvim-lspconfig | ↑ | 2026-03-02 | v2.6.0 (Feb 2025) deprecates old framework in favor of vim.lsp.config. Config already uses native API; update lockfile commit. |
| mason.nvim | ↑ | 2026-03-02 | v2.2.1 (Jan 2026). v2.0 (May 2025) was breaking: requires Nvim 0.10+, org moved to mason-org. |
| mason-lspconfig.nvim | ↑ | 2026-03-02 | v2.1.0 (Jul 2025). v2.0 removed handlers/automatic_installation, added automatic_enable. Config needs update. |
| conform.nvim | ↑ | 2026-03-02 | v9.1.0 (Aug 2025). v9.0 removed deprecated syntax. |
| rustaceanvim | ↑ | 2026-03-02 | v8.0.3 (Feb 2026). v8.0 BREAKING: removed .vscode/settings.json support. |
| telescope.nvim | ↑ | 2026-03-02 | v0.2.1 (Dec 2025). v0.2.0 dropped Nvim 0.9, requires 0.10.4+. |
| nvim-cmp | ✓ | 2026-03-02 | Active, latest commit Jan 2026 (da88697 matches lockfile). blink.cmp is a community alternative but not official successor. |
| copilot.lua | ↑ | 2026-03-02 | Active, latest commit Feb 28 2026. Pinned commit is behind. |

### Standard tier

| Plugin | Status | Date Checked | Notes |
|--------|--------|-------------|-------|
| gitsigns.nvim | ↑ | 2026-03-02 | v2.0.0 (Jan 2026). BREAKING: targets Nvim 0.11, removed custom highlight names, optional setup. |
| lualine.nvim | ✓ | 2026-03-02 | Updated Nov 2025. Active maintenance. |
| nvim-tree.lua | ✓ | 2026-03-02 | Updated Feb 2026. Active maintenance. |
| nvim-dap | ✓ | 2026-03-02 | v0.10.0 (Mar 2025). Last supporting Nvim 0.9.5; future requires 0.10+. |
| neotest | ✓ | 2026-03-02 | v5.13.0 (Oct 2025). Active. |
| iron.nvim | ✓ | 2026-03-02 | Latest commit Feb 20 2026 (88cd340 matches lockfile exactly). Current. |
| LuaSnip | ✓ | 2026-03-02 | v2.4.1 (Nov 2024). Stable, no major changes. |
| yanky.nvim | ✓ | 2026-03-02 | v2.0.0 (Nov 2024). Stable. |
| Comment.nvim | ✓ | 2026-03-02 | Active, not deprecated. Neovim 0.10+ has native gc commenting; consider removing. |
| R.nvim | ✓ | 2026-03-02 | v0.99.3 (Jan 2025). Active development toward 1.0. |
| ocaml.nvim | ✓ | 2026-03-02 | New plugin from Tarides. Pre-1.0, actively developed. |
| nvim-dap-ui | ✓ | 2026-03-02 | v4.0.0 (Mar 2025). Stable. |
| nvim-dap-python | ✓ | 2026-03-02 | Latest commit Dec 2025 (1808458 matches lockfile). Current. |
| cmp_luasnip | ✓ | 2026-03-02 | Latest commit Nov 2024 (98d9cb5 matches lockfile). Current. |
| cmp-nvim-lsp | ✓ | 2026-03-02 | Latest commit Nov 2025 (cbc7b02 matches lockfile). Current. |
| copilot-cmp | ✓ | 2026-03-02 | Low activity but functional. |
| nvim-web-devicons | ↑ | 2026-03-02 | Active, latest commits Feb 2026. Lockfile slightly behind. |
| vimtex | ✓ | 2026-03-02 | v2.17 (Oct 2024). Stable, no breaking changes. |
| lazy.nvim | ↑ | 2026-03-02 | v11.17.5 (Nov 2025). Lockfile behind. |
| plenary.nvim | ✓ | 2026-03-02 | Updated Jul 2025. Active. |
| nvim-nio | ✓ | 2026-03-02 | Active, used by neotest/dap-ui. |

### Stable/niche tier

| Plugin | Status | Date Checked | Notes |
|--------|--------|-------------|-------|
| catppuccin | ✓ | 2026-03-02 | Active. Stable colorscheme. |
| tokyonight.nvim | ✓ | 2026-03-02 | v4.14.1 (Oct 2025). Active. |
| kanagawa.nvim | ✓ | 2026-03-02 | Active, recent PRs in 2026. |
| rose-pine | ✓ | 2026-03-02 | Active. |
| stan-vim | ✓ | 2026-03-02 | Last release v1.2.0 (May 2021). Niche but functional, no changes needed. |
| eidos.vim | ✓ | 2026-03-02 | Personal plugin (vsbuffalo). |
| d2-vim | ✓ | 2026-03-02 | Updated Aug 2025. Stable. |
| snakemake | ✓ | 2026-03-02 | Syntax file from snakemake repo. Updated Mar 2025. |
| webapi-vim | ✓ | 2026-03-02 | Mature/stable. Infrequent updates. |
| mini.align | ✓ | 2026-03-02 | Part of mini.nvim ecosystem. Active. |
| FixCursorHold | ⚠ | 2026-03-02 | README says no longer needed after Nvim 0.8. Running Nvim 0.11. Should remove. |

## Recommended Actions

### Critical
1. **nvim-treesitter**: Master branch is archived. Pinned commit (42fc28b) is literally the archival announcement commit. Must migrate to `main` branch which is a full incompatible rewrite. This is a significant migration requiring config rewrite.

### High Priority
2. **mason-lspconfig.nvim**: v2.0 removed `handlers` and `automatic_installation`. Current config uses old `setup({ ensure_installed = ... })` pattern. Needs migration to `automatic_enable` pattern.
3. **FixCursorHold.nvim**: Unnecessary since Nvim 0.8. Remove from neotest dependencies and lazy.lua.
4. **gitsigns.nvim**: v2.0.0 targets Nvim 0.11 with breaking changes. Worth updating since we're on 0.11.2.
5. **rustaceanvim**: v8.0 removed .vscode/settings.json support. Check if this affects your workflow.

### Low Priority
6. **Comment.nvim**: Neovim 0.10+ has native `gc` commenting via treesitter. Consider whether this plugin is still needed.
7. General lockfile refresh for: copilot.lua, nvim-web-devicons, lazy.nvim, telescope.nvim, conform.nvim, mason.nvim.
