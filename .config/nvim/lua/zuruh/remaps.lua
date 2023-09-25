vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ih", function()
	vim.lsp.inlay_hint(0, nil)
end, { desc = "Toggle Inlay Hints" })
