-- after/plugin/nvimtree.lua
require("nvim-tree").setup({
    view = {
        width = 30,
        side = "left",
    },
    renderer = {
        icons = {
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
        },
    },
    filters = {
        dotfiles = false,
    },
    respect_buf_cwd = true,    -- makes nvim-tree use buffer's cwd
    sync_root_with_cwd = true, -- newer recommended way
})

-- Keymaps
-- <leader>e to toggle nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })

-- <leader>r to refresh nvim-tree
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { desc = 'Refresh NvimTree' })

-- <leader>f to find the current file in nvim-tree
vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { desc = "Reveal file in NvimTree" })
