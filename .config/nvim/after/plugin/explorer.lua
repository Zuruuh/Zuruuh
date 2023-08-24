-- require'netrw'.setup{
--  use_devicons = true,
-- }

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
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
})
vim.keymap.set("n", "<c-n>", ":NvimTreeFindFileToggle<CR>")
