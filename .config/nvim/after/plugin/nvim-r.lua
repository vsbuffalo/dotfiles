-- Nvim-R plugin configuration

require("R").setup({
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
