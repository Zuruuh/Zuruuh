local hour = tonumber(os.date("%H"))
local theme = require('onedark')

local style = 'dark'
if hour >= 8 and hour <= 20 then
    style = 'light'
    vim.o.background = "light"
end

theme.setup({
    style = style,
})
theme.load()
