require('barbar').setup({
    animation = false,
    auto_hide = true,
    tabpages = true,
    clickable = true,
    gitsigns = {
      added = {enabled = true, icon = '+'},
      changed = {enabled = true, icon = '~'},
      deleted = {enabled = true, icon = '-'},
    },
})
