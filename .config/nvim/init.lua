require("vinceb")

function GoToRustTests()
    local search_pattern = "#\\[cfg(test)\\]\\nmod tests {"
    local found = vim.fn.search(search_pattern, "W")

    if found == 0 then
        print("Test module not found in this file.")
    end
end

-- Create a Neovim command that calls the Lua function
vim.api.nvim_create_user_command('GoToRustTests', GoToRustTests, {})


-- add an unwrap
function AddUnwrapBeforeSemicolon()
    -- Move to the semicolon
    vim.cmd('normal f;')
    -- Enter insert mode and type .unwrap()
    vim.cmd('normal i.unwrap()')
    -- No need to explicitly leave insert mode as the command finishes in normal mode
end

vim.api.nvim_create_user_command('AddUnwrapBeforeSemicolon', AddUnwrapBeforeSemicolon, {})

-- add a command to list all active LSP clients
vim.api.nvim_create_user_command("LspClients", function()
  local buf = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(vim.inspect(vim.lsp.get_active_clients()), "\n"))
end, {})

-- copy LSP client info to clipboard
function CopyLspClientDebug()
  local clients = vim.lsp.get_active_clients()
  local debug_output = vim.inspect(clients)
  vim.fn.system('pbcopy', debug_output)
  vim.notify("✅ LSP client info copied to clipboard", vim.log.levels.INFO, { title = "LSP Debug" })
end
vim.keymap.set("n", "<leader>vc", CopyLspClientDebug, { noremap = true, silent = true, desc = "Copy LSP client info to clipboard" })


