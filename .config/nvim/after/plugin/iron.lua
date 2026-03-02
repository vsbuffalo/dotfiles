local iron = require("iron.core")
local view = require("iron.view")

iron.setup {
    config = {
        scratch_repl = true,
        repl_definition = {
            ocaml = {
                command = { "dune", "utop" },
            },
            python = {
                command = { "python3" },
            },
            sh = {
                command = { "zsh" },
            },
        },
        repl_open_cmd = view.split.vertical.rightbelow("40%"),
    },
    keymaps = {
        toggle_repl = "<leader>rr",
        restart_repl = "<leader>rR",
        send_motion = "<leader>sc",
        visual_send = "<leader>sc",
        send_file = "<leader>sf",
        send_line = "<leader>sl",
        send_paragraph = "<leader>sp",
        send_until_cursor = "<leader>su",
        cr = "<leader>s<cr>",
        interrupt = "<leader>s<space>",
    },
}
