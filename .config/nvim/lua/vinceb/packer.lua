local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

vim.cmd [[packadd packer.nvim]]

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- conform.nvim manages and apply code formatting configurations
    -- for various programming languages.
    use "stevearc/conform.nvim"

    -- nvim-tree is a file explorer for Neovim.
    use 'nvim-tree/nvim-web-devicons'
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    -- lualine.nvim is a fast and easy-to-configure statusline plugin for Neovim.
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({ options = { theme = 'tokyonight' } })
        end,
    }

    -- copilot.lua is a Neovim plugin that provides GitHub Copilot support.
    use { 'zbirenbaum/copilot.lua' }

    -- copilot-cmp is a Neovim plugin that integrates GitHub Copilot
    -- with nvim-cmp, the completion engine for Neovim.
    use {
        'zbirenbaum/copilot-cmp',
        after = { 'copilot.lua' },
        config = function()
            require('copilot_cmp').setup()
        end,
    }

    -- telescope.nvim is a fuzzy finder for Neovim.
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.5',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- neotest is a Neovim plugin for running and managing tests.
    use {
        "nvim-neotest/neotest",
        requires = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        }
    }

    -- snakemake.nvim is a Neovim plugin for Snakemake, a workflow management system.
    use {
        'snakemake/snakemake',
        rtp = 'misc/vim/',
        ft = { 'snakemake' }
    }

    -- webapi-vim is a Neovim plugin for web API testing.
    use 'mattn/webapi-vim'

    -- nvim-r is a Neovim plugin for R language support.
    use 'jalvesaq/Nvim-R'

    -- comment.nvim is a Neovim plugin for easy commenting of code.
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    -- treesitter.nvim is a Neovim plugin for syntax highlighting and code parsing.
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- fugitive.vim is a Git wrapper for Neovim.
    use 'tpope/vim-fugitive'

    -- rust-tools.nvim is a Neovim plugin for Rust development.
    use { 'simrat39/rust-tools.nvim' }

    --lsp-zero.nvim is a Neovim plugin for configuring LSP (Language Server Protocol) clients.
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- vimtex is a Neovim plugin for LaTeX editing.
    use 'lervag/vimtex'

    -- yanky.nvim is a Neovim plugin for managing the yank history.
    use {
        'gbprod/yanky.nvim',
        config = function()
            require("yanky").setup({
                ring = {
                    history_length = 100,
                    storage = "shada",
                    sync_with_numbered_registers = true,
                    cancel_event = "update",
                },
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 500,
                },
            })
        end,
    }

    -- stan-vim is a Neovim plugin for Stan language support.
    use 'eigenfoo/stan-vim'

    -- eidos.vim is a Neovim plugin for Eidos, a tool for creating and managing Eidos models.
    use 'vsbuffalo/eidos.vim'

    -- rose-pine is a Neovim color scheme.
    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    }

    -- tokyonight.nvim is a Neovim color scheme.
    use {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    }

    -- kanagawa.nvim is a Neovim color scheme.
    use "rebelot/kanagawa.nvim"

    -- catppuccin.nvim is a Neovim color scheme.
    use { "catppuccin/nvim", as = "catppuccin" }

    if packer_bootstrap then
        require('packer').sync()
    end
end)
