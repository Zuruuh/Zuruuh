return {
	"navarasu/onedark.nvim",
	config = function()
		local hour = tonumber(os.date("%H"))
		local theme = require("onedark")

		local style = "dark"
		if hour >= 8 and hour <= 18 then
			style = "light"
			vim.o.background = "light"
		end

		theme.setup({
			style = style,
		})
		theme.load()

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = vim.schedule_wrap(function()
				vim.cmd([[
            augroup ColorScheme
                autocmd! hi BufferCurrentIndex guibg=transparent
            augroup end
        ]])
			end),
			group = vim.api.nvim_create_augroup("zuruh", {}),
		})
	end,
}
