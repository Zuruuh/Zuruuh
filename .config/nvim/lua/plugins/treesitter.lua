return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()

		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"astro",
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"git_config",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"html",
				"javascript",
				"json",
				"json5",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				"ocaml",
				"php",
				"python",
				"requirements",
				"query",
				"rust",
				"scss",
				"sql",
				"toml",
				"tsx",
				"twig",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},

			sync_install = true,
			auto_install = true,

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},

			indent = {
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
	end,
}
