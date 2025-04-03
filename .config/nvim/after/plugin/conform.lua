require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format", "ruff_fix" }, -- run format *then* fix
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})

require("conform").formatters.ruff_fix = {
  command = "ruff",
  args = { "--fix", "--exit-zero", "--stdin-filename", "$FILENAME", "-" },
  stdin = true,
}

