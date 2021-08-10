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
local beautiful = require('beautiful')
awful = require('awful')

require("lib-tde.luapath")
require('awful.autofocus')

awful.util.shell = 'sh'


require("global_var")
require("module.state")


require("collision")()
require('layout')


require('configuration.client')
require('configuration.tags')
root.keys(require('configuration.keys.global'))

require('module')

screen.connect_signal(
	'request::wallpaper',
	function(s)
		-- If wallpaper is a function, call it with the screen
		if beautiful.wallpaper then
			if type(beautiful.wallpaper) == 'string' then

				-- Check if beautiful.wallpaper is color/image
				if beautiful.wallpaper:sub(1, #'#') == '#' then
					-- If beautiful.wallpaper is color
					gears.wallpaper.set(beautiful.wallpaper)

				elseif beautiful.wallpaper:sub(1, #'/') == '/' then
					-- If beautiful.wallpaper is path/image
					gears.wallpaper.maximized(beautiful.wallpaper, s)
				end
			else
				beautiful.wallpaper(s)
			end
		end
	end
)

require('module.version_update_news')
