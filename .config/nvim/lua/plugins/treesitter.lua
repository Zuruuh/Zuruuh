return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"javascript",
				"typescript",
				"rust",
				"lua",
				"vim",
				"vimdoc",
				"query",
			},

			sync_install = false,

			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			rainbow = {
				enable = true,
			},
		})

		require("treesitter-context").setup({
			enable = true,
			max_lines = 3,
		})

		require("nvim-ts-autotag").setup({
			autotag = {
				enable = true,
			},
		})

		local parsers = require("nvim-treesitter.parsers").get_parser_configs()

		parsers.just = {
			install_info = {
				url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
				files = { "src/parser.c", "src/scanner.cc" },
				branch = "main",
				-- use_makefile = true -- this may be necessary on MacOS (try if you see compiler errors)
			},
			maintainers = { "@IndianBoy42" },
		}

		parsers.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}
	end,
}
