vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--[[
return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	opts = {
		git = { enable = true },
		renderer = {
			highlight_git = true,
			icons = {
				show = {
					git = true,
				},
			},
		},
		view = {
			side = "right",
		},
	},
}
]]
--

return {
	"nvim-neo-tree/neo-tree.nvim",
	lazy = false,
	keys = {
		{
			"<leader>pv",
			vim.cmd.Neotree,
		},
	},
	opts = {
		window = {
			position = "right",
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
}
