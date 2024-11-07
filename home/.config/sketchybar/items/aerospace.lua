local settings = require('settings')
local colors = require('colors')

local aerospace = sbar.add('item', {
  label = {
    color = colors.white,
    padding_right = 8,
    width = 14,
    align = 'right',
    font = {
      family = settings.font.numbersize,
      style = 'Heavy',
    },
  },
  position = 'right',
  update_freq = 3,
  padding_left = 1,
  padding_right = 1,
  background = {
    color = colors.bg2,
    border_color = colors.black,
    border_width = 1,
  },
})

aerospace:subscribe({ 'forced', 'routine' }, function()
  sbar.exec('aerospace list-workspaces --focused', function(result, exit_code)
    aerospace:set({
      label = exit_code == 0 and result or '?',
    })
  end)
end)
