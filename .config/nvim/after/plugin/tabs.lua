local bufferline = require("bufferline")

bufferline.setup({
	options = {
		separator_style = "slant",
		numbers = "ordinal",
	},
})
-- local barbar = require('barbar')
--
-- barbar.setup({
--     animation = false,
--     auto_hide = false,
--     tabpages = true,
--     clickable = true,
--     icons = {
--         buffer_index = true,
--         preset = "slanted",
--     },
--     gitsigns = {
--         added = {enabled = true, icon = '+'},
--         changed = {enabled = true, icon = '~'},
--         deleted = {enabled = true, icon = '-'},
--     },
-- })

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-w>", "<Cmd>BufferLinePickClose<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<C-S-t>", "<Cmd>BufferRestore<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>1", "<Cmd>BufferLineGoToBuffer 1<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>2", "<Cmd>BufferLineGoToBuffer 2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>3", "<Cmd>BufferLineGoToBuffer 3<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>4", "<Cmd>BufferLineGoToBuffer 4<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>5", "<Cmd>BufferLineGoToBuffer 5<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>6", "<Cmd>BufferLineGoToBuffer 6<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>7", "<Cmd>BufferLineGoToBuffer 7<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>8", "<Cmd>BufferLineGoToBuffer 8<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>9", "<Cmd>BufferLineGoToBuffer 9<CR>", opts)
-- vim.api.nvim_set_keymap('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)
