--[[
--MIT License
--
--Copyright (c) 2019 manilarome
--Copyright (c) 2020 Tom Meyers
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.
]]
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local progressbar = require('lib-widget.progress_bar')
local config = require("config")
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')
local delayed_timer = require("lib-tde.function.delayed-timer")
local filehandle = require('lib-tde.file')

local meter_name = wibox.widget {
	text = 'Temperature',
	font = 'Inter Bold 10',
	align = 'left',
	widget = wibox.widget.textbox
}

local icon = wibox.widget {
	layout = wibox.layout.align.vertical,
	expand = 'none',
	nil,
	{
		image = icons.thermometer,
		resize = true,
		widget = wibox.widget.imagebox
	},
	nil
}

local meter_icon = wibox.widget {
	{
		icon,
		margins = dpi(5),
		widget = wibox.container.margin
	},
	bg = beautiful.groups_bg,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, beautiful.groups_radius)
	end,
	widget = wibox.container.background
}

local meter = progressbar()
meter.forced_height = dpi(36)

local slider = wibox.widget {
	nil,
	meter,
	nil,
	expand = 'none',
	forced_height = dpi(36),
	layout = wibox.layout.align.vertical
}

local max_temp = 80

delayed_timer(
  config.temp_poll,
  function()
    local stdout = filehandle.string("/sys/class/thermal/thermal_zone0/temp") or ""
    if stdout == "" then
      return
    end
    local temp = stdout:match("(%d+)")
    meter:set_value((temp / 1000) / max_temp * 100)
    print("Current temperature: " .. (temp / 1000) .. " °C")
  end,
  config.temp_startup_delay
)

local temp_meter = wibox.widget {
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(5),
	meter_name,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = 'none',
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				forced_height = dpi(24),
				forced_width = dpi(24),
				meter_icon
			},
			nil
		},
		slider
	}
}

return temp_meter
