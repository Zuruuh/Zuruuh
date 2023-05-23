local barbar = require('barbar')

barbar.setup({
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    gitsigns = {
      added = {enabled = true, icon = '+'},
      changed = {enabled = true, icon = '~'},
      deleted = {enabled = true, icon = '-'},
    },
})

-- vim.keymap.set("n", "<C-w>", barbar)
vim.api.nvim_set_keymap("n", "<C-w>", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })
