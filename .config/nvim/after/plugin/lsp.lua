-- NOTES ON KEYBINDING FIXES:
-- The diagnostic float mapping (<leader>vd) needs to be wrapped in a function()
-- otherwise Neovim may interpret 'v' as a visual mode command followed by 'd' for delete.
-- The wrapper function prevents this interpretation and ensures the mapping works as intended.
-- Additionally, using opts = {buffer = bufnr, remap = false, noremap = true} ensures
-- the mapping won't be overridden or misinterpreted by other configurations.

local lsp = require('lsp-zero')
lsp.preset('recommended')

-- Skip pylsp, use ruff
lsp.skip_server_setup({ "pylsp" })

-- Keep the sign column open
vim.opt.signcolumn = 'yes'

-- Install language servers
lsp.ensure_installed({
    'texlab',
    'clangd',
    'rust_analyzer',
    'pyright',  -- for type checking and hover
})

-- Rust-specific config
lsp.configure('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = { allFeatures = true },
            procMacro = { enable = true },
        }
    }
})

-- Common on_attach for all LSPs
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
end

-- Hook our custom on_attach
lsp.on_attach(my_on_attach)

-- Set up workspace for lua
lsp.nvim_workspace()

-- Setup lsp-zero
lsp.setup()

-- Global fallback for diagnostic popup (in case LSP doesn't attach)
vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
end, { noremap = true, silent = true })


-- Ruff LSP setup
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
    cmd = get_ruff_cmd(),
    filetypes = { "python" },
    root_dir = root_dir,
    init_options = {
        settings = {
            args = {},
        },
    },
    on_attach = my_on_attach,
})

local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv_python = cwd .. "/.venv/bin/python"
  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end
  return "python"
end

local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv_python = cwd .. "/.venv/bin/python"
  if vim.fn.executable(venv_python) == 1 then
    return venv_python
  end
  return "python"
end

-- Force update pyright config after setup
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
        diagnosticMode = "workspace", -- ✅ override
      }
    }
  }
})

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
