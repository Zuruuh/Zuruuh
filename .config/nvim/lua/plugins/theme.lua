local theme = "dracula"
-- local theme = "onedark"

return {
	"f-person/auto-dark-mode.nvim",
	dependencies = { "navarasu/onedark.nvim", "Mofiqul/dracula.nvim" },
	config = function()
		local auto_dark_mode = require("auto-dark-mode")
		auto_dark_mode.setup({
			update_interval = 1000,
			set_dark_mode = function()
				vim.o.background = "dark"
			end,
			set_light_mode = function()
				vim.o.background = "light"
			end,
		})

		vim.cmd([[colorscheme dracula]])
	end,
}
