local eslint = function()
	return require("formatter.defaults").eslint_d
end
local prettier = function()
	return require("formatter.defaults").prettierd
end

return {
	-- "mhartington/formatter.nvim",
	"shreve/formatter.nvim", -- temporary until #empty-fix is merged
	branch = "empty-fix",
	lazy = false,
	keys = {
		{ "<leader>f", "<CMD>Format<CR>", desc = "Format", silent = true, noremap = true },
	},
	module = "formatter",
	config = function()
		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				lua = require("formatter.filetypes.lua").stylua,
				javascript = eslint(),
				typescript = eslint(),
				javascriptreact = eslint(),
				typescriptreact = eslint(),
				astro = eslint(),
				html = prettier(),
				css = prettier(),
				json = prettier(),
				markdown = prettier(),
				sh = require("formatter.filetypes.sh").shfmt,
				toml = require("formatter.filetypes.toml").taplo,
				yaml = prettier(),
				rust = require("formatter.filetypes.rust").rustfmt,
				php = {
					-- require("formatter.filetypes.php").phpcbf,
					require("formatter.filetypes.php").php_cs_fixer,
				},

				["*"] = {
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			},
		})
	end,
}
