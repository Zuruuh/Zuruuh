local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "ignore_case",
		},
	},
})

telescope.load_extension("live_grep_args")
telescope.load_extension("fzf")

vim.keymap.set("n", "<leader>pf", builtin.git_files, {})
vim.keymap.set("n", "<C-p>", function()
	builtin.find_files({ hidden = true })
end, {})
vim.keymap.set("n", "<leader>fg", telescope.extensions.live_grep_args.live_grep_args, {})
