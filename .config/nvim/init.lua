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

