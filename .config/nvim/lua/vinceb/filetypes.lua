-- tell nvim to treat Snakefiles as python
-- this is approximate, could be fixed later with a paper LSP
vim.cmd.au("BufNewFile,BufRead Snakefile set syntax=python")
vim.cmd.au("BufNewFile,BufRead *.snake set syntax=python")

-- camdl compartmental modelling DSL
vim.filetype.add({ extension = { camdl = "camdl" } })
vim.treesitter.language.register("camdl", "camdl")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "camdl",
  callback = function() vim.treesitter.start() end,
})
