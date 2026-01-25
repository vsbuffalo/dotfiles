vim.g["vimtex_syntax_enabled"] = 0
vim.g["vimtex_view_method"] = "skim"
vim.g["vimtex_compiler_progname"] = 'nvr'
vim.g["vimtex_view_general_viewer"] = '/Applications/Skim.app/Contents/SharedSupport/displayline'
vim.g["vimtex_view_general_options"] = '-r @line @pdf @tex'

-- Configure VimTeX quickfix behavior
-- Don't automatically open quickfix - you can manually open with :copen
vim.g["vimtex_quickfix_mode"] = 0  -- 0 = never auto-open, 1 = open on warnings/errors, 2 = always open

-- If you want it to open but stay in background (no focus stealing):
-- vim.g["vimtex_quickfix_mode"] = 2
-- vim.g["vimtex_quickfix_autojump"] = 0  -- Don't jump to first error
-- vim.g["vimtex_quickfix_open_on_warning"] = 0  -- Don't open on warnings

-- When you DO open quickfix manually, make it smaller
vim.g["vimtex_quickfix_height"] = 5  -- Set height to 5 lines

-- Optional: Close quickfix after a few keystrokes when you're done reviewing
-- vim.g["vimtex_quickfix_autoclose_after_keystrokes"] = 2

