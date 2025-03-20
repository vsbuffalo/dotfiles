local builtin = require('telescope.builtin')

require('telescope').setup{
  defaults = {
    file_ignore_patterns = {
      "LICENSE",
      "profile.json",
      "node_modules",
      "build/.*",
      "%.git/.*",
      "target/.*",   -- for Rust projects
      "%.o",         -- object files
      "%.a",         -- static libraries
      "%.out",
      "duckdb/.*",   -- ignore duckdb directory
                     -- when working on extensions
      "third_party/.*",
      "__pycache__/.*",
      "%.pyc",
    },
  }
}

vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- To search in all files including ignored ones
vim.keymap.set('n', '<leader>pa', function()
    builtin.find_files({ no_ignore = true })
end, {})

-- fast live grep 
vim.keymap.set('n', '<leader>tg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>td', builtin.diagnostics, {})

