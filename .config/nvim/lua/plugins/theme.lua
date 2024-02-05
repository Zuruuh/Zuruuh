return {
	"f-person/auto-dark-mode.nvim",
	dependencies = { "Mofiqul/vscode.nvim" },
	config = function()
		local auto_dark_mode = require("auto-dark-mode")
		auto_dark_mode.setup({
			update_interval = 1000,
			set_dark_mode = function()
				vim.o.background = "dark"
			end,
			set_light_mode = function()
				-- vim.o.background = "light"
				vim.o.background = "dark"
			end,
		})

		require("vscode").setup({
			italic_comments = true,
		})

		require("vscode").load()
	end,
}
