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
    vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end, opts)
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
    ensure_installed = { "pyright", "ruff", "clangd", "texlab" },
})

-- Helper function for finding project root
local function root_pattern(...)
    local patterns = {...}
    return function(fname)
        fname = fname or vim.fn.getcwd()
        for _, pattern in ipairs(patterns) do
            local match = vim.fs.find(pattern, {
                path = fname,
                upward = true,
                stop = vim.env.HOME,
            })[1]
            if match then
                return vim.fn.fnamemodify(match, ':h')
            end
        end
        return vim.fn.getcwd()
    end
end

local root_dir = root_pattern("pyproject.toml", "setup.cfg", "requirements.txt", ".git")

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

-- Custom Pyright setup
local function get_python_path()
    local cwd = vim.fn.getcwd()
    local venv_python = cwd .. "/.venv/bin/python"
    if vim.fn.executable(venv_python) == 1 then
        return venv_python
    end
    return "python"
end

-- Configure LSP servers using Neovim 0.11's native API
vim.lsp.config('pyright', {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { "pyproject.toml", "setup.cfg", "requirements.txt", ".git" },
    on_attach = my_on_attach,
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

vim.lsp.config('ruff', {
    cmd = get_ruff_cmd(),
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.cfg", "requirements.txt", ".git" },
    on_attach = my_on_attach,
    init_options = {
        settings = {
            args = {},
        },
    },
})

-- rust_analyzer is managed by rustaceanvim — do not configure here

vim.lsp.config('clangd', {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt' },
    on_attach = my_on_attach,
})

vim.lsp.config('texlab', {
    cmd = { 'texlab' },
    filetypes = { 'tex', 'plaintex', 'bib' },
    root_markers = { '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml' },
    on_attach = my_on_attach,
})

vim.lsp.config('ocamllsp', {
    cmd = { 'ocamllsp' },
    filetypes = { 'ocaml', 'ocaml.interface', 'ocaml.menhir', 'ocaml.ocamllex' },
    root_markers = { 'dune-project', 'dune-workspace', '*.opam', '.git' },
    on_attach = my_on_attach,
})

-- Enable all configured LSP servers
vim.lsp.enable({ 'pyright', 'ruff', 'clangd', 'texlab', 'ocamllsp' })

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
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
    }
})
