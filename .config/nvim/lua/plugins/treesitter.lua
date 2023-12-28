return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	dependencies = {
		"nvim-treesitter/nvim-treesitter-context",
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local parsers = require("nvim-treesitter.parsers").get_parser_configs()

		parsers.just = {
			install_info = {
				url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
				files = { "src/parser.c", "src/scanner.cc" },
				branch = "main",
				use_makefile = true,
			},
			maintainers = { "@IndianBoy42" },
		}

		parsers.nu = {
			install_info = {
				url = "https://github.com/nushell/tree-sitter-nu",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "nu",
		}

		parsers.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}

		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"astro",
				"bash",
				"blade",
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
				"just",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"nix",
				"nu",
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
