
vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.scrolloff = 8

vim.opt.relativenumber = true

-- spell check
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Built-in autocompletion (Neovim 0.12+).
-- Triggers the ins-completion popup as you type. Sources controlled by 'complete'.
-- LSP completion is enabled per-buffer in after/plugin/lsp.lua via vim.lsp.completion.enable.
vim.o.autocomplete = true
vim.o.completeopt = "menu,menuone,noinsert,popup,fuzzy"
-- '.' current buffer · 'w' other windows · 'b' loaded buffers · 'u' unloaded buffers
-- 't' tags · 'F{func}' user func (LSP via vim.lsp.completion plugs in here)
vim.o.complete = ".,w,b,u,t"


-- OSC 52 clipboard — works over SSH + tmux to reach the local terminal
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Netrw settings
-- Tell netrw to use SSH config file (hosts, keys, settings in ~/.ssh/config)
vim.g.netrw_ssh_cmd = "ssh -F " .. os.getenv("HOME") .. "/.ssh/config"
vim.g.netrw_scp_cmd = "scp -F " .. os.getenv("HOME") .. "/.ssh/config"
vim.g.netrw_silent = 1
vim.g.netrw_keepdir = 0
