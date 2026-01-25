require("copilot").setup({
  suggestion = {
    enabled = false, -- disable to use copilot-cmp
    auto_trigger = false,
  },
})

require("copilot_cmp").setup()
