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
local beautiful = require('beautiful')
local watch = awful.widget.watch
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local config_dir = gears.filesystem.get_configuration_dir()
local widget_dir = config_dir .. 'widget/bluetooth-toggle/'
local widget_icon_dir = widget_dir .. 'icons/'
local signals = require('lib-tde.signals')
local device_state = false

local action_name = wibox.widget {
    text = i18n.translate('Bluetooth'),
    font = 'Inter Bold 10',
    align = 'left',
    widget = wibox.widget.textbox
}

local action_status = wibox.widget {
    text = i18n.translate('Off'),
    font = 'Inter Regular 10',
    align = 'left',
    widget = wibox.widget.textbox
}

local action_info = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    action_name,
    action_status
}

local button_widget = wibox.widget {
    {
        id = 'icon',
        image = widget_icon_dir .. 'bluetooth-off.svg',
        widget = wibox.widget.imagebox,
        resize = true
    },
    layout = wibox.layout.align.horizontal
}

local widget_button = wibox.widget {
    {
        {
            button_widget,
            margins = dpi(15),
            forced_height = dpi(48),
            forced_width = dpi(48),
            widget = wibox.container.margin
        },
        widget = clickable_container
    },
    bg = beautiful.groups_bg,
    shape = gears.shape.circle,
    widget = wibox.container.background
}

local update_widget = function()
    if device_state then
        action_status:set_text(i18n.translate('On'))
        widget_button.bg = beautiful.primary.hue_600
        button_widget.icon:set_image(widget_icon_dir .. 'bluetooth.svg')
    else
        action_status:set_text(i18n.translate('Off'))
        widget_button.bg = beautiful.groups_bg
        button_widget.icon:set_image(widget_icon_dir .. 'bluetooth-off.svg')
    end
end

signals.connect_primary_theme_changed(function(pallet)
    if device_state then
        widget_button.bg = pallet.hue_600
    else
        widget_button.bg = beautiful.groups_bg
    end
end)

local check_device_state = function(stdout)
	local function calc(_stdout)
	    if _stdout:match('Soft blocked: yes') then
			device_state = false
		else
			device_state = true
		end
		update_widget()
	end

	if stdout ~= nil then
		return calc(stdout)
	end

	awful.spawn.easy_async("rfkill list bluetooth", calc)
end

check_device_state()
local power_on_cmd = [[
	rfkill unblock bluetooth

	# Create an AwesomeWM Notification
	tde-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'Initializing bluetooth device...',
		icon = ']] .. widget_icon_dir .. 'loading' .. '.svg' .. [['
	})
	"

	# Add a delay here so we can enable the bluetooth
	sleep 1

	bluetoothctl power on
]]

local power_off_cmd = [[
	bluetoothctl power off
	rfkill block bluetooth

	# Create an AwesomeWM Notification
	tde-client "
	naughty = require('naughty')
	naughty.notification({
		app_name = 'Bluetooth Manager',
		title = 'System Notification',
		message = 'The bluetooth device has been disabled.',
		icon = ']] .. widget_icon_dir .. 'bluetooth-off' .. '.svg' .. [['
	})
	"
]]

local toggle_action = function()
    if device_state then
        awful.spawn.easy_async_with_shell(power_off_cmd, function(_)
            device_state = false
            update_widget()
        end)
    else
        awful.spawn.easy_async_with_shell(power_on_cmd, function(_)
            device_state = true
            update_widget()
        end)
    end
end

widget_button:buttons(gears.table.join(awful.button({}, 1, nil, function()
    toggle_action()
end)))

action_info:buttons(gears.table.join(awful.button({}, 1, nil, function()
    toggle_action()
end)))

watch('rfkill list bluetooth', 5, function(_, stdout)
    check_device_state(stdout)
end)

local action_widget = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(10),
    widget_button,
    {
        layout = wibox.layout.align.vertical,
        expand = 'none',
        nil,
        action_info,
        nil
    }

}

return action_widget
