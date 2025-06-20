-- Nvim-R plugin configuration

-- Only configure if R.nvim is available
local status_ok, r = pcall(require, "R")
if not status_ok then
    return
end

r.setup({
    R_args = { "--quiet", "--no-save" },
    hook = {
        on_filetype = function()
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine", {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>", "<Plug>RSendSelection", {})
        end,
    },
    -- these are causing issues with neovim
    -- shiftwidth = 2,
    -- tabstop = 2,
    -- softtabstop = 2,
    -- xpandtab = true,
    -- rconsole_width = 120,   -- how wide the R pane should be
    -- min_editor_width = 120, -- how wide your code pane should be
})

-- Horizontal split for R console
-- require("r").setup({
--     rconsole_width = 0,
--     rconsole_height = 15, -- how many lines tall the R pane should be
-- })