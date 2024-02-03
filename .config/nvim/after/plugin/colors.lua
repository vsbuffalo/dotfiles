require('rose-pine')
require('tokyonight')
require('kanagawa')
require('catppuccin')

function ColorEverything(color) 
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end

-- ColorEverything("tokyonight-moon")
-- ColorEverything("kanagawa")
-- ColorEverything("tokyonight-night")

local M = {}

-- Define a list of color schemes to cycle through
M.color_schemes = {
    -- "rose-pine",
    "tokyonight",
    "catppuccin",
    "tokyonight-moon",
    "tokyonight-night",
    "kanagawa",
}

-- Current index in the color schemes list
M.current_index = 1

-- Function to apply the color scheme based on the current index
function M.apply_color_scheme()
    local color = M.color_schemes[M.current_index]
    vim.cmd.colorscheme(color)
end

-- Function to cycle to the next color scheme
function M.cycle_color_scheme()
    M.current_index = M.current_index + 1
    -- Wrap around if we reach the end of the list
    if M.current_index > #M.color_schemes then
        M.current_index = 1
    end
    M.apply_color_scheme()
    vim.cmd('redraw') -- Force Neovim to redraw the screen
    local current_scheme = M.color_schemes[M.current_index]
    vim.notify("Color scheme set to: " .. current_scheme, vim.log.levels.INFO)
end

-- Neovim command to cycle color schemes
vim.api.nvim_create_user_command('CycleColorScheme', M.cycle_color_scheme, {})

return M

