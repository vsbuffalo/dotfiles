-- Treesitter setup for nvim-treesitter `main` branch (Neovim 0.12+).
--
-- Unlike the old `master` branch, the main branch does NOT auto-enable
-- highlighting/folding/indent. We enable them here per buffer via a
-- FileType autocmd. Parsers are installed in lua/vinceb/lazy.lua.
--
-- Highlight: provided by core Neovim (vim.treesitter.start).
-- Folding:   provided by core Neovim (vim.treesitter.foldexpr).
-- Indent:    provided by the plugin (still experimental — enable selectively).

local big_file_kb = 100 -- skip treesitter on files larger than this

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("vinceb-treesitter", { clear = true }),
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        if ft == "" then return end

        -- Skip if no parser is available for this filetype.
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then return end
        local ok = pcall(vim.treesitter.language.add, lang)
        if not ok then return end

        -- Skip large files to keep highlighting snappy.
        local ok_stat, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok_stat and stats and stats.size > big_file_kb * 1024 then return end

        -- Highlight (core).
        pcall(vim.treesitter.start, buf)

        -- Folding via treesitter is opt-in — uncomment if you want it, and
        -- also raise vim.o.foldlevelstart in set.lua so files don't open
        -- collapsed.
        -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- vim.wo[0][0].foldmethod = "expr"
    end,
})
