local dap = require('dap')
local dapui = require('dapui')

-- Setup DAP UI
dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                "breakpoints",
                "stacks",
                "watches",
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                "repl",
                "console",
            },
            size = 0.25,
            position = "bottom",
        },
    },
})

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- Python configuration
require('dap-python').setup()
-- This will look for debugpy in your virtual environment first
require('dap-python').resolve_python = function()
    local venv_path = vim.fn.getcwd() .. '/.venv'
    if vim.fn.isdirectory(venv_path) == 1 then
        return venv_path .. '/bin/python'
    end
    return '/usr/bin/python3'
end

-- Python debug configurations
dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',  -- This will debug the current file
        pythonPath = function()
            local venv_path = vim.fn.getcwd() .. '/.venv'
            if vim.fn.isdirectory(venv_path) == 1 then
                return venv_path .. '/bin/python'
            end
            return '/usr/bin/python3'
        end,
    },
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file with arguments',
        program = '${file}',
        args = function()
            local args_string = vim.fn.input('Arguments: ')
            return vim.split(args_string, " ")
        end,
        pythonPath = function()
            local venv_path = vim.fn.getcwd() .. '/.venv'
            if vim.fn.isdirectory(venv_path) == 1 then
                return venv_path .. '/bin/python'
            end
            return '/usr/bin/python3'
        end,
    },
}

-- Debug keymaps
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Set conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue/Start debugging' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Run last debug configuration' })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<leader>dx', dap.terminate, { desc = 'Terminate debug session' })

-- Evaluate variable under cursor
vim.keymap.set({'n', 'v'}, '<leader>de', function()
    dapui.eval()
end, { desc = 'Evaluate expression' })

-- Visual indicators
vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointCondition', {text='🟡', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='⭕', texthl='DapBreakpoint', linehl='', numhl=''})
vim.fn.sign_define('DapLogPoint', {text='📝', texthl='DapLogPoint', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='▶️', texthl='DapStopped', linehl='DapStopped', numhl='DapStopped'})