local settings = require('settings')
local colors = require('colors')
local icons = require('icons')

local bluetooth = sbar.add('item', {
  icon = {
    color = colors.white,
    padding_left = 8,
    font = {
      style = settings.font.style_map['Black'],
      size = 12.0,
    },
  },
  label = {
    color = colors.white,
    padding_right = 8,
    width = 'dynamic',
    align = 'right',
    font = { family = settings.font.numbers },
  },
  position = 'right',
  update_freq = 30,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
  },
})

bluetooth:subscribe({ 'forced', 'routine' }, function()
  sbar.exec("blueutil --connected --format json | jq -re '.[0].name'", function(result, exit_code)
    bluetooth:set({
      icon = {
        string = icons.bluetooth,
      },
      label = exit_code == 0 and result or 'None',
    })
  end)
end)
