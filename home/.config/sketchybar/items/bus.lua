local settings = require('settings')
local colors = require('colors')
local icons = require('icons')

local buses = {
  [20] = {
    monitoring = 'STIF:StopPoint:Q:29279:',
    line = 'STIF:Line::C01072:',
    color = 0xffff9243,
  },
  [84] = {
    monitoring = 'STIF:StopPoint:Q:462449:',
    line = 'STIF:Line::C01116:',
    color = 0xffc5a4cf,
  },
  [94] = {
    monitoring = 'STIF:StopPoint:Q:26280:',
    line = 'STIF:Line::C01125:',
    color = 0xffbc509c,
  },
}

local apikey_path = os.getenv('API_KEY_FILE')
if apikey_path == nil then
  print('Could not get the API_KEY_FILE env var ?')
  return
end

local apikey = nil

sbar.exec('cat ' .. apikey_path, function(result, exit_code)
  if exit_code == 1 then
    print('Could not read the apikey at ' .. apikey_path)
    return
  end

  apikey = result
end)

local function create_command(monitoring, line)
  if apikey == nil then
    return nil
  end

  return string.format(
    [[ http get \
      https://prim.iledefrance-mobilites.fr/marketplace/stop-monitoring?MonitoringRef=%s&LineRef=%s \
      --headers [apiKey %s] |
      get Siri.ServiceDelivery.StopMonitoringDelivery.0 | 
      get MonitoredStopVisit.MonitoredVehicleJourney | 
      get MonitoredCall.ExpectedDepartureTime |
      into datetime |
      each {format date '%s'} |
      each {into int} |
      each {|date| \$date - (date now | format date '%s' | into int)} |
      each {|estimatedSeconds| \$estimatedSeconds / 60 | math floor} |
      last
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
    drawing = false,
    updating = true,
    icon = {
      string = icons.bus,
      color = colors.white,
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
      font = {
        family = settings.font.numbers,
        style = 'Heavy',
      },
    },
    position = 'right',
    update_freq = 90,
    padding_left = 1,
    padding_right = 1,
    background = {
      color = bus_data.color,
      border_color = colors.black,
      border_width = 1,
    },
  })

  bus:subscribe({ 'forced', 'routine' }, function()
    local hour = tonumber(os.date('%H'))
    if hour <= 15 or hour >= 20 then
      bus:set({
        drawing = false,
        updating = true,
      })

      return
    end

    local command = create_command(bus_data.monitoring, bus_data.line)
    if command == nil then
      bus:set({
        drawing = true,
        update = true,
        label = string.format('%s: ?', bus_id),
      })
      return
    end

    sbar.exec(string.format('nu -c "%s"', command), function(result, exit_code)
      if exit_code ~= 0 then
        print('Api not working ?')
      end

      if exit_code ~= 0 then
        print(result)
      end

      bus:set({
        drawing = true,
        update = true,
        label = exit_code == 0 and string.format('%s: %sm', bus_id, result) or string.format('%s: ?', bus_id),
      })
    end)
  end)
end
