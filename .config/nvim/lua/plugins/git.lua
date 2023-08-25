return {
	"tpope/vim-fugitive",
	cmd = "Git",
	keys = {
		{ "<leader>gs", vim.cmd.Git },
		{ "<leader>gss", vim.cmd.Git },
		{ "<leader>gf", "<CMD>diffget //2<CR>" },
		{ "<leader>gh", "<CMD>diffget //3<CR>" },
		{ "<leader>gs-", "<CMD>Git switch -<CR>", silent = true },
		{ "<leader>gpl", "<CMD>Git pull<CR>", silent = true },
		{ "<leader>gpp", "<CMD>Git push<CR>", silent = true },
		{ "<leader>gph", "<CMD>Git push -u origin HEAD<CR>", silent = true },
		{ "<leader>ggfl", "<CMD>Git push --force-with-lease<CR>", silent = true },
		{
			"<leader>gsd",
			function()
				os.execute([[
    command git rev-parse --git-dir &> /dev/null || return
    for branch in dev develop development; do
        if command git show-ref -q --verify refs/heads/$branch; then
            git switch $branch
            break
        fi;
    done;
        ]])
			end,
			silent = true,
		},
	},
}
