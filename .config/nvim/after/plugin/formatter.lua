local util = require("formatter.util")
local defaults = require("formatter.defaults")

local eslint = defaults.eslint_d
local prettier = defaults.prettierd

require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		lua = require("formatter.filetypes.lua").stylua,
		javascript = eslint,
		typescript = eslint,
		javascriptreact = eslint,
		typescriptreact = eslint,
		astro = eslint,
		html = prettier,
		css = prettier,
		json = prettier,
		markdown = prettier,
		sh = require("formatter.filetypes.sh").shfmt,
		toml = require("formatter.filetypes.toml").taplo,
		yaml = prettier,
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

vim.keymap.set("n", "<leader>f", "<CMD>Format<CR>", { silent = true, noremap = true })
