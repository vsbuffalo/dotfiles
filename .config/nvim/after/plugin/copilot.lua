-- Copilot configuration.
--
-- After migrating away from nvim-cmp, copilot-cmp is gone — there is no
-- equivalent source plugin for the built-in completion menu yet. Copilot
-- now must be used via ghost text (inline virtual-text suggestions) if at all.
--
-- suggestion.enabled = false keeps Copilot quiet; flip to true to enable
-- ghost text (Tab accepts by default; see copilot.lua docs for full keys).
require("copilot").setup({
  suggestion = {
    enabled = false,
    auto_trigger = false,
  },
})

-- require("copilot_cmp").setup()  -- removed with nvim-cmp
