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
local gears = require('gears')
local wibox = require('wibox')
local awful = require('awful')
local ruled = require('ruled')
local naughty = require('naughty')
local menubar = require('menubar')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.padding = dpi(10)
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = 'System Notification'
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0
naughty.config.defaults.position = 'top_right'
naughty.config.defaults.shape = function(cr, w, h)
	gears.shape.rounded_rect(cr, w, h, dpi(10))
end

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
	'/usr/share/icons/Tela',
	'/usr/share/icons/Tela-blue-dark',
	'/usr/share/icons/Papirus/',
	'/usr/share/icons/la-capitaine-icon-theme/',
	'/usr/share/icons/gnome/',
	'/usr/share/icons/hicolor/',
	'/usr/share/pixmaps/'
}
naughty.config.icon_formats = { 'svg', 'png', 'jpg', 'gif' }


-- Presets / rules

ruled.notification.connect_signal(
	'request::rules',
	function()

		-- Critical notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'critical' },
			properties = {
				font        		= 'Inter Bold 10',
				bg 					= '#ff0000',
				fg 					= '#ffffff',
				margin 				= dpi(16),
				position 			= 'top_right',
				implicit_timeout	= 0
			}
		}

		-- Normal notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'normal' },
			properties = {
				font        		= 'Inter Regular 10',
				bg      			= beautiful.transparent,
				fg 					= beautiful.fg_normal,
				margin 				= dpi(16),
				position 			= 'top_right',
				implicit_timeout 	= 5
			}
		}

		-- Low notifs
		ruled.notification.append_rule {
			rule       = { urgency = 'low' },
			properties = {
				font        		= 'Inter Regular 10',
				bg     				= beautiful.transparent,
				fg 					= beautiful.fg_normal,
				margin 				= dpi(16),
				position 			= 'top_right',
				implicit_timeout	= 5
			}
		}
	end
	)

-- Error handling
naughty.connect_signal(
	'request::display_error',
	function(message, startup)
		naughty.notification {
			urgency = 'critical',
			title   = 'Oops, an error happened'..(startup and ' during startup!' or '!'),
			message = message,
			app_name = i18n.translate('System Notification'),
			icon = beautiful.tde_icon
		}
	end
)

-- XDG icon lookup
naughty.connect_signal(
	'request::icon',
	function(n, context, hints)
		if context ~= 'app_icon' then return end

		local path = menubar.utils.lookup_icon(hints.app_icon) or
		menubar.utils.lookup_icon(hints.app_icon:lower())

		if path then
			n.icon = path
		end
	end
)

-- Connect to naughty on display signal
naughty.connect_signal(
	'request::display',
	function(n)

		-- Actions Blueprint
		local actions_template = wibox.widget {
			notification = n,
			base_layout = wibox.widget {
				spacing        = dpi(0),
				layout         = wibox.layout.flex.horizontal
			},
			widget_template = {
				{
					{
						{
							{
								id     = 'text_role',
								font   = 'Inter Regular 10',
								widget = wibox.widget.textbox
							},
							widget = wibox.container.place
						},
						widget = clickable_container
					},
					bg                 = beautiful.groups_bg,
					shape              = gears.shape.rounded_rect,
					forced_height      = dpi(30),
					widget             = wibox.container.background
				},
				margins = dpi(4),
				widget  = wibox.container.margin
			},
			style = { underline_normal = false, underline_selected = true },
			widget = naughty.list.actions
		}

		-- Notifbox Blueprint
		naughty.layout.box {
			notification = n,
			type = 'notification',
			screen = awful.screen.preferred(),
			shape = gears.shape.rectangle,
			widget_template = {
				{
					{
						{
							{
								{
									{
										{
											{
												{
													{
														markup = n.title or n.app_name or i18n.translate('System Notification'),
														font = 'Inter Bold 10',
														align = 'center',
														valign = 'center',
														widget = wibox.widget.textbox

													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												bg = beautiful.primary.hue_600 .. beautiful.background_transparency,
												widget  = wibox.container.background,
											},
											{
												{
													{
														resize_strategy = 'center',
														widget = naughty.widget.icon,
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												{
													{
														layout = wibox.layout.align.vertical,
														expand = 'none',
														nil,
														{
															align = 'left',
															widget = naughty.widget.message,
														},
														nil
													},
													margins = beautiful.notification_margin,
													widget  = wibox.container.margin,
												},
												layout = wibox.layout.fixed.horizontal,
											},
											fill_space = true,
											spacing = beautiful.notification_margin,
											layout  = wibox.layout.fixed.vertical,
										},
										-- Margin between the fake background
										-- Set to 0 to preserve the 'titlebar' effect
										margins = dpi(0),
										widget  = wibox.container.margin,
									},
									bg = beautiful.groups_bg,
									widget  = wibox.container.background,
								},
								-- Actions
								actions_template,
								spacing = dpi(4),
								layout  = wibox.layout.fixed.vertical,
							},
							bg     = beautiful.groups_bg,
							id     = 'background_role',
							widget = naughty.container.background,
						},
						strategy = 'min',
						width    = dpi(250),
						widget   = wibox.container.constraint,
					},
					strategy = 'max',
					height    = dpi(250),
					width    = dpi(250),
					widget   = wibox.container.constraint
				},
				bg = beautiful.groups_bg .. beautiful.background_transparency,
				shape = gears.shape.rounded_rect,
				widget = wibox.container.background
			}
		}

		-- Destroy popups if dont_disturb_state mode is on
		-- Or if the info_center is visible
		local focused = awful.screen.focused()
		if _G.save_state.do_not_disturb or (focused.info_center and focused.info_center.visible) then
			naughty.destroy_all_notifications(nil, 1)
		end
	end
)
