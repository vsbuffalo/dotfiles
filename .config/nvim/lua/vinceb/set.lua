
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


-- Netrw settings
-- Tell netrw to use SSH config file (hosts, keys, settings in ~/.ssh/config)
vim.g.netrw_ssh_cmd = "ssh -F " .. os.getenv("HOME") .. "/.ssh/config"
vim.g.netrw_scp_cmd = "scp -F " .. os.getenv("HOME") .. "/.ssh/config"
vim.g.netrw_silent = 1
vim.g.netrw_keepdir = 0
