# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Plugin Management
- **Install/Update plugins**: Open Neovim and run `:Lazy sync` or use `<leader>ss` keybinding
- **Add new plugin**: Edit `lua/vinceb/lazy.lua` and add the plugin specification, then run `:Lazy sync`

### Development in this Codebase
- **Reload configuration**: `:source %` in the current file or restart Neovim
- **Debug LSP issues**: Use the custom `CopyLspClientDebug` command to copy LSP client info to clipboard
- **Test changes**: Open a file of the relevant type to test LSP, formatting, and plugin functionality

## Architecture

This Neovim configuration follows a modular architecture inspired by ThePrimeagen's setup:

1. **Entry Point** (`init.lua`): Loads the core module and defines custom helper functions
2. **Core Module** (`lua/vinceb/`): Contains all core configuration
   - `init.lua`: Module loader that requires all submodules
   - `lazy.lua`: Plugin declarations and lazy.nvim setup
   - `remap.lua`: Global key mappings (leader = space)
   - `set.lua`: Vim options and settings
   - `filetypes.lua`: Custom filetype detection

3. **Plugin Configurations** (`after/plugin/`): Individual plugin setups that run after plugins load
   - Each plugin has its own configuration file
   - Recently migrated from lsp-zero to native LSP with Mason

4. **Key Design Decisions**:
   - **Python Environment Detection**: Automatically prefers `.venv` over system Python in `after/plugin/lsp.lua`
   - **LSP Architecture**: Uses Mason for LSP installation, nvim-lspconfig for server setup, and nvim-cmp for completions
   - **Formatting**: Handled by conform.nvim (configured in `after/plugin/conform.lua`), currently only Ruff for Python
   - **Testing**: Uses neotest framework with Python adapter

When modifying this configuration:
- Plugin additions go in `lua/vinceb/lazy.lua`
- Plugin configurations go in `after/plugin/<plugin-name>.lua`
- Global settings modifications go in `lua/vinceb/set.lua`
- Key mappings go in `lua/vinceb/remap.lua` (global) or in the relevant plugin file (plugin-specific)