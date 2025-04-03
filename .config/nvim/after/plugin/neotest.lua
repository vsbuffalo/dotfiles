-- after/plugin/neotest.lua
local neotest = require("neotest")

neotest.setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },    -- optional, useful for debugging
            args = { "--capture=no", "-q" }, -- optional: disable output capture for richer logs
            runner = "pytest",               -- force pytest, even if unittest is available
        }),
    },

    -- Optional output UI
    output = {
        enabled = true,
        open_on_run = "short", -- "always", "short", "never"
    },

    quickfix = {
        enabled = false, -- you can use trouble.nvim or native quickfix
    },
})

-- 🔑 Keymaps for running tests
vim.keymap.set("n", "<leader>tt", function()
    neotest.run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>tf", function()
    neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run tests in current file" })

vim.keymap.set("n", "<leader>td", function()
    neotest.run.run({ strategy = "dap" })
end, { desc = "Debug nearest test (DAP)" })

vim.keymap.set("n", "<leader>ts", function()
    neotest.summary.toggle()
end, { desc = "Toggle test summary panel" })

vim.keymap.set("n", "<leader>to", function()
    neotest.output.open({ enter = true })
end, { desc = "Show test output" })

vim.keymap.set("n", "<leader>tl", function()
    neotest.run.run_last()
end, { desc = "Run last test" })
