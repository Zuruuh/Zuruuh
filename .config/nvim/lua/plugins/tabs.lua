return {
	"akinsho/bufferline.nvim",
	lazy = false,
	-- vim.api.nvim_set_keymap("n", "<C-S-t>", "<Cmd>BufferRestore<CR>", opts)
	-- vim.api.nvim_set_keymap('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)
	keys = {
		{ "<C-w>", "<Cmd>BufferLinePickClose<CR>" },
		{ "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>" },
		{ "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>" },
		{ "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>" },
		{ "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>" },
		{ "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>" },
		{ "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>" },
		{ "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>" },
		{ "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>" },
		{ "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>" },
	},
	opts = {
		options = {
			separator_style = "slant",
			numbers = "ordinal",
		},
	},
}
