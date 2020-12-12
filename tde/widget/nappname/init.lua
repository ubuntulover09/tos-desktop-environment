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
----------------------------------------------------------------------------
--- A notification app_name.
--
-- This widget is a specialized `wibox.widget.textbox` with the following extra
-- features:
--
-- * Honor the `beautiful` notification variables.
--
--
-- @author Andy Freidenfelds &lt;afreidenfelds@gmail.com&gt;
-- @copyright 2020 Andy Freidenfelds
-- @widgetmod naughty.widget.appname
-- @see wibox.widget.textbox
----------------------------------------------------------------------------
local gtable = require("gears.table")
local beautiful = require("beautiful")
local textbox = require("wibox.widget.textbox")
local markup = require("naughty.widget._markup").set_markup
local appname = {}

function appname:set_notification(notif)
    if self._private.notification == notif then
        return
    end

    markup(self, notif.app_name, notif.fg, notif.font)
    self._private.notification = notif
    self:emit_signal("property::notification", notif)
end

local function new(args)
    args = args or {}
    local tb = textbox()
    tb:set_wrap("word")
    tb:set_font(beautiful.notification_font)

    gtable.crush(tb, appname, true)

    if args.notification then
        tb:set_notification(args.notification)
    end

    return tb
end

return setmetatable(
    appname,
    {__call = function(_, ...)
            return new(...)
        end}
)
