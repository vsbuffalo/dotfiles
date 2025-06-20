require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        },
    },

    sections = {
        lualine_a = { 'filename' },
        lualine_b = { 'mode' },
        lualine_c = { 'branch', 'diff', 'diagnostics' },
        lualine_x = {
            -- 🐍 Show Python virtual environment
            {
                function()
                    local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_DEFAULT_ENV")
                    if venv then
                        return " " .. vim.fn.fnamemodify(venv, ":t")
                    end
                    return ""
                end,
                icon = "",
                color = { fg = "#98be65" },
            },

            -- ⚡ Show active LSP server
            {
                function()
                    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                    if next(buf_clients) == nil then
                        return ""
                    end
                    local client_names = {}
                    for _, client in pairs(buf_clients) do
                        table.insert(client_names, client.name)
                    end
                    return " " .. table.concat(client_names, ", ")
                end,
                color = { fg = "#80a0ff" },
            },
        },
        lualine_y = { 'filetype' },
        lualine_z = { 'progress' },
    },

    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },

    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { 'nvim-tree', 'fugitive', 'quickfix' },
}
