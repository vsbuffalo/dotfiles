require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_format", "ruff_fix" },  -- built-ins work
  },
})
