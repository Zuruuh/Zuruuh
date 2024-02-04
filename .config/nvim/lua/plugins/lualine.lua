return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	opts = {
		options = {
			icons_enabled = true,
			theme = "dracula",
			-- theme = "onedark",
		},
		sections = {
			lualine_a = {
				{
					"filename",
					path = 1,
				},
			},
		},
	},
}
