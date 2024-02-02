require('rose-pine')
require('tokyonight')
require('kanagawa')

function ColorEverything(color) 
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end

ColorEverything("tokyonight-moon")
ColorEverything("kanagawa")
-- ColorEverything("tokyonight-night")
