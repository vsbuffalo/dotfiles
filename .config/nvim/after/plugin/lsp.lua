-- NOTES ON KEYBINDING FIXES:
-- The diagnostic float mapping (<leader>vd) needs to be wrapped in a function()
-- otherwise Neovim may interpret 'v' as a visual mode command followed by 'd' for delete.
-- The wrapper function prevents this interpretation and ensures the mapping works as intended.
-- Additionally, using opts = {buffer = bufnr, remap = false, noremap = true} ensures
-- the mapping won't be overridden or misinterpreted by other configurations.
-- Keep the sign column visible

vim.opt.signcolumn = 'yes'

-- Keybinding: diagnostic float fallback
vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, { noremap = true, silent = true })

-- Shared on_attach function for all servers
local function my_on_attach(client, bufnr)
    if client.name == "ruff" then
        client.server_capabilities.hoverProvider = false
    end

    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set("n", "<leader>vd", function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    if client.name == "ruff" then
        print("✅ Ruff attached with config from: " .. client.config.root_dir)
    end
end

-- Prefer .venv binaries over system/Mason
local venv = vim.fn.getcwd() .. "/.venv/bin"
if vim.fn.isdirectory(venv) == 1 then
    vim.env.PATH = venv .. ":" .. vim.env.PATH
end

-- Mason + LSP config
require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "ruff", "rust_analyzer", "clangd", "texlab" },
    automatic_enable = false, -- ⛔ turn off the new auto-start feature
})

-- now MANUALLY enable only what you want
local on = { on_attach = my_on_attach }

require("lspconfig").pyright.setup(on)
require("lspconfig").ruff.setup(on)
require("lspconfig").rust_analyzer.setup(on)
require("lspconfig").clangd.setup(on)
require("lspconfig").texlab.setup(on)


-- Custom Ruff setup
local util = require("lspconfig.util")
local root_dir = util.root_pattern("pyproject.toml", "setup.cfg", "requirements.txt", ".git")

local function get_ruff_cmd()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return { venv .. "/bin/ruff", "server" }
    end

    local project_venv = root_dir(vim.fn.getcwd()) .. "/.venv/bin/ruff"
    if vim.fn.executable(project_venv) == 1 then
        return { project_venv, "server" }
    end

    return { "ruff", "server" }
end

require('lspconfig').ruff.setup({
    --cmd = get_ruff_cmd(),
    filetypes = { "python" },
    root_dir = root_dir,
    init_options = {
        settings = {
            args = {},
        },
    },
    on_attach = my_on_attach,
})

-- Custom Pyright setup
local function get_python_path()
    local cwd = vim.fn.getcwd()
    local venv_python = cwd .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
        return venv_python
    end
    return "python"
end

require('lspconfig').pyright.setup({
    on_attach = my_on_attach,
    root_dir = root_dir,
    settings = {
        python = {
            pythonPath = get_python_path(),
            analysis = {
                typeCheckingMode = "basic",
                reportUnusedImport = false,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            }
        }
    }
})

-- Autocompletion with nvim-cmp
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
    }
})
