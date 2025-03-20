-- NOTES ON KEYBINDING FIXES:
-- The diagnostic float mapping (<leader>vd) needs to be wrapped in a function()
-- otherwise Neovim may interpret 'v' as a visual mode command followed by 'd' for delete.
-- The wrapper function prevents this interpretation and ensures the mapping works as intended.
-- Additionally, using opts = {buffer = bufnr, remap = false, noremap = true} ensures
-- the mapping won't be overridden or misinterpreted by other configurations.


local lsp = require('lsp-zero')
lsp.preset('recommended')

-- don't keep opening/closing that darn flag column
vim.opt.signcolumn = 'yes'

lsp.ensure_installed({
    'texlab',
    'pylsp',
    'clangd',
    'rust_analyzer',
    --'r_language_server'
})

-- Configure rust-analyzer specifically
local rust_lsp = {
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
            checkOnSave = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            },
        }
    }
}

lsp.configure('rust_analyzer', rust_lsp)
lsp.nvim_workspace()

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false, noremap = true}
    
    vim.keymap.set("n", "<leader>vd", function() 
        vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    end, opts)
    
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    -- mapping= {
    --     -- don't make enter complete the first selected item; 
    --     -- C-y only, enter is enter.
    --     ['<CR>'] = cmp.mapping.confirm({ select = false }),
    --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    --     ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    --     ["<C-Space>"] = cmp.mapping.complete(),
    -- }
})
