-- after/plugin/nvimtree.lua
require("nvim-tree").setup({
    view = {
        width = 30,
    },
    filters = {
        dotfiles = false,
    },
    sync_root_with_cwd = true,
})

-- Keymaps
-- <leader>e to toggle nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle NvimTree' })

-- <leader>r to refresh nvim-tree
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { desc = 'Refresh NvimTree' })

-- <leader>f to find the current file in nvim-tree
vim.keymap.set('n', '<leader>f', ':NvimTreeFindFile<CR>', { desc = "Reveal file in NvimTree" })
