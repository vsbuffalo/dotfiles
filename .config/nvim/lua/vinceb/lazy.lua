-- Lazy.nvim plugin specifications
local plugins = {
    -- conform.nvim manages and apply code formatting configurations
    "stevearc/conform.nvim",

    -- nvim-tree file explorer
    "nvim-tree/nvim-web-devicons",
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    {
        "terrastruct/d2-vim",
        ft = "d2",
        config = function()
            -- Override the problematic function
            vim.cmd([[
            function! d2#syntax_post() abort
            if !exists('b:included_syntaxes')
                let b:included_syntaxes = []
                endif
                " Rest of the function will run normally
                endfunction
                ]])
            end,
        },

    -- lualine statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('lualine').setup({ options = { theme = 'tokyonight' } })
        end,
    },

    -- GitHub Copilot
    { "zbirenbaum/copilot.lua" },
    { "zbirenbaum/copilot-cmp" },
    { "neovim/nvim-lspconfig" },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Mason LSP installer
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

    -- Copilot-cmp integration
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require('copilot_cmp').setup()
        end,
    },

    -- Telescope fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- Neotest test runner
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        }
    },

    -- mini.align for text alignment
    {
        "echasnovski/mini.align",
        branch = "stable",
        config = function()
            require('mini.align').setup()
            vim.keymap.set({ 'n', 'x' }, 'ga', '<Plug>(minialign-start)')
            vim.keymap.set({ 'n', 'x' }, 'gA', '<Plug>(minialign-start-with-preview)')
        end,
    },

    -- Snakemake support
    {
        "snakemake/snakemake",
        config = function()
            vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/snakemake/misc/vim")
        end,
        ft = { "snakemake" }
    },

    -- Web API support
    "mattn/webapi-vim",

    -- R language support
    {
        "R-nvim/R.nvim",
        lazy = false,
        config = function()
            -- R.nvim configuration is in after/plugin/nvim-r.lua
        end,
    },

    {
        "R-nvim/cmp-r",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
            -- CMP configuration is handled in after/plugin/lsp.lua
            local status_ok, cmp_r = pcall(require, "cmp_r")
            if status_ok then
                cmp_r.setup({})
            end
        end,
    },

    -- Comment plugin
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup()
        end
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require('gitsigns').setup {
                current_line_blame = true,
                current_line_blame_opts = {
                    delay = 250,
                    virt_text_pos = 'eol',
                },
                current_line_blame_formatter = ' <author>, <author_time:%Y-%m-%d> - <summary>',
            }
            vim.keymap.set('n', '<leader>bb', function()
                require('gitsigns').toggle_current_line_blame()
            end, { desc = ' Toggle git blame for current line' })
        end
    },

    -- Rust tools
    { "simrat39/rust-tools.nvim" },

    -- LaTeX support
    "lervag/vimtex",

    -- Yanky yank history
    {
        "gbprod/yanky.nvim",
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
    },

    -- Stan language support
    "eigenfoo/stan-vim",

    -- Eidos support
    "vsbuffalo/eidos.vim",

    -- Color schemes
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
    },

    "rebelot/kanagawa.nvim",

    { "catppuccin/nvim", name = "catppuccin" },

    -- Debug Adapter Protocol
    { "mfussenegger/nvim-dap" },
    
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    },
    
    { "mfussenegger/nvim-dap-python" },
}

-- Setup lazy.nvim
require("lazy").setup(plugins, {
    -- Lazy.nvim configuration options
    install = {
        -- install missing plugins on startup
        missing = true,
    },
    ui = {
        -- a number <1 is a percentage., >1 is a fixed size
        size = { width = 0.8, height = 0.8 },
        wrap = true,
        border = "rounded",
    },
})
