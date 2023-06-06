vim.keymap.set("n", "<leader>gs", vim.cmd.Git);
vim.keymap.set("n", "gh", "<cmd>diffget //2<CR>");
vim.keymap.set("n", "gl", "<cmd>diffget //3<CR>");
vim.keymap.set("n", "<leader>bd", function () os.execute([[
    command git rev-parse --git-dir &> /dev/null || return
    for branch in dev develop development; do
        if command git show-ref -q --verify refs/heads/$branch; then
            git switch $branch
            break
        fi;
    done;
]]) end)
