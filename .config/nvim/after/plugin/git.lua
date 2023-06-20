vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gss", vim.cmd.Git)
vim.keymap.set("n", "<leader>gl", "<CMD>diffget //2<CR>")
vim.keymap.set("n", "<leader>gr", "<CMD>diffget //3<CR>")
vim.keymap.set("n", "<leader>gsd", function () os.execute([[
    command git rev-parse --git-dir &> /dev/null || return
    for branch in dev develop development; do
        if command git show-ref -q --verify refs/heads/$branch; then
            git switch $branch
            break
        fi;
    done;
]]) end)
vim.keymap.set("n", "<leader>gs-", "<CMD>Git switch -<CR>")
vim.keymap.set("n", "<leader>gpl", "<CMD>Git pull<CR>")
vim.keymap.set("n", "<leader>gpp", "<CMD>Git push<CR>")
vim.keymap.set("n", "<leader>gph", "<CMD>Git push -u origin HEAD<CR>")
vim.keymap.set("n", "<leader>ggfl", "<CMD>Git push --force-with-lease<CR>")
