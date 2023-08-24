require("nvim_comment").setup({})

vim.keymap.set("n", "<C-_>", function()
	print("Use gc{motion}!")
end)
