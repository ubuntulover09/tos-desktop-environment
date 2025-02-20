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
local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/tray-toggle/icons/'

local widget = wibox.widget {
	{
		id = 'icon',
		image = widget_icon_dir .. 'right-arrow' .. '.svg',
		widget = wibox.widget.imagebox,
		resize = true
	},
	layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
	{
		widget,
		margins = dpi(7),
		widget = wibox.container.margin
	},
	widget = clickable_container
}

widget_button:buttons(
	gears.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				tde.emit_signal('widget::systray:toggle')
			end
		)
	)
)

-- Listen to signal
tde.connect_signal(
	'widget::systray:toggle',
	function()
		if screen.primary.systray then

			if not screen.primary.systray.visible then

				widget.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. 'left-arrow.svg'))
			else

				widget.icon:set_image(gears.surface.load_uncached(widget_icon_dir .. 'right-arrow.svg'))
			end

			screen.primary.systray.visible = not screen.primary.systray.visible
		end
	end
)

-- Update icon on start-up
if screen.primary.systray then
	if screen.primary.systray.visible then
		widget.icon:set_image(widget_icon_dir .. 'right-arrow' .. '.svg')
	end
end

-- Show only the tray button in the primary screen
return awful.widget.only_on_screen(widget_button, 'primary')
