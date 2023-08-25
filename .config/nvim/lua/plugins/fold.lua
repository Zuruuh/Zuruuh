local ufo = function()
	return require("ufo")
end

return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	keys = {
		{
			"zR",
			function()
				ufo().openAllFolds()
			end,
		},
		{
			"zM",
			function()
				ufo().closeAllFolds()
			end,
		},
	},
	config = function()
		vim.o.foldcolumn = "1"
		vim.o.foldlevel = 99
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		ufo().setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
}
