return {
	"navarasu/onedark.nvim",
	dependencies = { "f-person/auto-dark-mode.nvim" },
	config = function()
		local theme = require("onedark")
		local auto_dark_mode = require("auto-dark-mode")
		auto_dark_mode.setup({
			update_interval = 1000,
			set_dark_mode = function()
				vim.o.background = "dark"
				vim.cmd("colorscheme onedark")
			end,
			set_light_mode = function()
				vim.o.background = "light"
				vim.cmd("colorscheme onedark")
			end,
		})

		theme.setup()

		-- vim.api.nvim_create_autocmd("ColorScheme", {
		-- 	callback = vim.schedule_wrap(function()
		-- 		vim.cmd([[
		--             augroup ColorScheme
		--                 autocmd! hi BufferCurrentIndex guibg=transparent
		--             augroup end
		--         ]])
		-- 	end),
		-- 	group = vim.api.nvim_create_augroup("zuruh", {}),
		-- })
	end,
}
