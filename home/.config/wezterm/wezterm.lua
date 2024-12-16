local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config.font = wezterm.font({
  family = 'MonaspiceAr Nerd Font',
  -- family = 'MonaspiceNe Nerd Font',
  harfbuzz_features = { 'calt', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09', 'liga' },
})

config.enable_tab_bar = false
config.line_height = 1.5

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local home = os.getenv('HOME')

if home == nil then
  -- Windows
  config.default_prog = {
    'C:\\Windows\\system32\\wsl.exe',
    '--distribution',
    'Nixos',
    '--cd',
    '/home/zuruh',
    '--',
    '/run/current-system/sw/bin/zellij',
  }
  config.font_size = 14.0
elseif home:find('^/Users/') then
  -- Darwin
  config.default_prog = { '/run/current-system/sw/bin/zellij' }
  config.font_size = 18.0
end

config.keys = {
  { key = 'v', mods = 'CTRL', action = act.PasteFrom('Clipboard') },
}

return config
