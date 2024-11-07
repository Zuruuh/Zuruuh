local settings = require('settings')
local colors = require('colors')
local icons = require('icons')

local buses = {
  [20] = {
    monitoring = 'STIF:StopPoint:Q:29279:',
    line = 'STIF:Line::C01072:',
    color = 0xffff9243,
  },
  -- [84] = {},
  -- [94] = {},
}

local apikey_file = io.open(os.getenv('XDG_DATA_HOME') .. '/idf-mobilites-api-key.txt', 'r')
if not apikey_file then
  return
end
local apikey = apikey_file:read('*a')
apikey_file:close()

local function create_command(monitoring, line)
  return string.format(
    [[
    http get \
      https://prim.iledefrance-mobilites.fr/marketplace/stop-monitoring?MonitoringRef=%s&LineRef=%s \
      --headers [apiKey %s] |
      get Siri.ServiceDelivery.StopMonitoringDelivery.0 | 
      get MonitoredStopVisit.MonitoredVehicleJourney | 
      get MonitoredCall.ExpectedDepartureTime |
      into datetime |
      each {format date '%s'} |
      each {into int} |
      each {|date| $date - (date now | format date '%s' | into int)} |
      each {|estimatedSeconds| $estimatedSeconds / 60 | math floor}
    ]],
    monitoring,
    line,
    apikey,
    '%s',
    '%s'
  )
end

for bus_id, bus_data in pairs(buses) do
  local bus = sbar.add('item', {
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
      color = bus_data.color,
      border_color = colors.black,
      border_width = 1,
    },
  })

  bus:subscribe({ 'forced', 'routine' }, function()
    local hour = os.date('%H')
    if hour < 17 or hour > 19 then
      return
    end

    sbar.exec(string.format('nu -c "%s"', create_command(bus_data.monitoring, bus_data.line)), function(result, exit_code)
      if exit_code == 0 then
        print('Api not working ?')
      end

      bus:set({
        label = exit_code == 0 and string.format('%s: %s', bus_id, result) or 'None',
      })
    end)
  end)
end
