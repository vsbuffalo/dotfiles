vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- mimic emacs delete word, I have this set on my keyboard 
-- as a single button
vim.keymap.set("i", "<Esc><BS>", "<C-w>")

-- movement between adjacent buffers
vim.keymap.set("n", "<C-j>", vim.cmd.bp)
vim.keymap.set("n", "<C-k>", vim.cmd.bn)

-- fast save
vim.keymap.set("n", "<leader>w", ":w<cr>")

-- fast close buffer, preserving the window
vim.keymap.set("n", "<leader>bd", ":b#|bd#<cr>")

-- fast quit
vim.keymap.set("n", "<leader>q", ":q<cr>")

-- move blocks of text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- combine previous line
vim.keymap.set("n", "J", "mzJ`z")

-- keep cursor in middle
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- paste into system clipboad, from asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- quick access to packer edit ('se') and packer sync ('ss)
vim.keymap.set("n", "<leader>se", ":vs<CR>:e $HOME/.config/nvim/lua/vinceb/packer.lua<CR>")
vim.keymap.set("n", "<leader>ss", vim.cmd.PackerSync)

-- quick access to remap edit ('re')
vim.keymap.set("n", "<leader>re", ":vs<CR>:e $HOME/.config/nvim/lua/vinceb/remap.lua<CR>")

-- quick access to the plugins config directory
vim.keymap.set("n", "<leader>pe", ":vs<CR>:e $HOME/.config/nvim/after/plugin/<CR>")

-- quick rerun init
vim.keymap.set("n", "<leader>pp", ":source $HOME/.config/nvim/init.lua<CR>")

-- navigation hacks to move around split buffers more effectively
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- emacs-like movement in insert mode
vim.keymap.set("i", "<M-b>", "<Esc>b")
vim.keymap.set("i", "<M-f>", "<Esc>f")

-- in terminal mode, leader-Esc gets us out
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

-- work wrap magic (TODO still slow)
vim.keymap.set("n", "<leader><space>", "gwip")

-- stop hlsearch, until next time
vim.keymap.set("n", "<leader>h", ":noh<CR>")
