local barbar = require('barbar')

barbar.setup({
    animation = false,
    auto_hide = false,
    tabpages = true,
    clickable = true,
    icons = {
      buffer_index = true,
    },
    gitsigns = {
      added = {enabled = true, icon = '+'},
      changed = {enabled = true, icon = '~'},
      deleted = {enabled = true, icon = '-'},
    },
})

-- vim.keymap.set("n", "<C-w>", barbar)
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<C-w>", "<Cmd>BufferClose<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-S-t>", "<Cmd>BufferRestore<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>1', '<Cmd>BufferGoto 1<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>2', '<Cmd>BufferGoto 2<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>3', '<Cmd>BufferGoto 3<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>4', '<Cmd>BufferGoto 4<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>5', '<Cmd>BufferGoto 5<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>6', '<Cmd>BufferGoto 6<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>7', '<Cmd>BufferGoto 7<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>8', '<Cmd>BufferGoto 8<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>9', '<Cmd>BufferGoto 9<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>0', '<Cmd>BufferLast<CR>', opts)
