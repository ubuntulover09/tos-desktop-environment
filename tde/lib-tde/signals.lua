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
---------------------------------------------------------------------------
-- Internal signal delegator, this module manages signals from and to different components of TDE
--
-- This package contains a lot of signals.
-- most are in the form:
--
--     emit_property_ram("123450")
--     connect_property_ram(
--      function(value)
--        print("Received: " .. value)
--      end)
--
-- This module tries to improve re-usage of know variables throughout the tde infrastructure.
--
--
-- @author Tom Meyers
-- @copyright 2020 Tom Meyers
-- @tdemod lib-tde.signals
---------------------------------------------------------------------------

local connections = {}

local weak = {}
setmetatable(connections, weak)
weak.__mode = "k"

--- Notify other TDE components that the exit_screen should be hidden
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct emit_module_exit_screen_hide
-- @usage -- notify other components
-- lib-tde.signals.emit_module_exit_screen_hide()
connections.emit_module_exit_screen_hide = function()
    tde.emit_signal("module::exit_screen_hide")
end

--- Trigger a callback function when the exit screen goes hidden
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_module_exit_screen_hide
-- @usage -- notify other components
-- lib-tde.signals.connect_module_exit_screen_hide(
--    function ()
--      print("exit screen hidden")
--    end)
connections.connect_module_exit_screen_hide = function(func)
    tde.connect_signal("module::exit_screen_hide", func)
end

--- Notify other TDE components that the battery has updated its value
-- @staticfct emit_module_exit_screen_show
-- @usage -- notify other components
-- lib-tde.signals.emit_module_exit_screen_show()
connections.emit_module_exit_screen_show = function()
    tde.emit_signal("module::exit_screen_show")
end

--- Trigger a callback function when the exit screen is being show
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_module_exit_screen_show
-- @usage -- notify other components
-- lib-tde.signals.connect_module_exit_screen_show(
--    function ()
--      print("exit screen shown")
--    end)
connections.connect_module_exit_screen_show = function(func)
    tde.connect_signal("module::exit_screen_show", func)
end

--- Notify other TDE components that the battery has updated its value
-- @tparam number value The current percentage of the battery
-- @staticfct emit_module_battery
-- @usage -- notify other components when the battery is updated
-- lib-tde.signals.emit_battery()
connections.emit_battery = function(value)
    tde.emit_signal("module::battery", value)
end

--- Trigger a callback function when the battery is updated
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_battery
-- @usage -- notify other components when the battery updates
-- lib-tde.signals.connect_battery(
--    function (value)
--      print("Battery is: " .. tostring(value))
--    end)
connections.connect_battery = function(func)
    tde.connect_signal("module::battery", func)
end

--- Notify other TDE components that the battery charging has changed
-- @tparam bool value if it is charging
-- @staticfct emit_module_battery_charging
-- @usage -- notify other components when the battery charging changed
-- lib-tde.signals.emit_battery_charging()
connections.emit_battery_charging = function(value)
    tde.emit_signal("module::charger", value)
end

--- Trigger a callback function when the battery charging changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_battery_charging
-- @usage -- notify other components when the battery charging updates
-- lib-tde.signals.connect_battery(
--    function (value)
--      print("Battery charging state: " .. tostring(value))
--    end)
connections.connect_battery_charging = function(func)
    tde.connect_signal("module::charger", func)
end

--- Notify other TDE components that the screen brightness has changed
-- @tparam number value The brightness between 0 and 100
-- @staticfct emit_brightness
-- @usage -- notify other components when the brightness changed
-- lib-tde.signals.emit_brightness(100)
connections.emit_brightness = function(value)
    tde.emit_signal("brightness::update", value)
end

--- Trigger a callback function when the brightness changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_brightness
-- @usage -- notify other components when the brightness changed
-- lib-tde.signals.connect_brightness(
--    function (value)
--      print("Current brightness: " .. tostring(value))
--    end)
connections.connect_brightness = function(func)
    tde.connect_signal("brightness::update", func)
end

--- Notify other TDE components that the screen volume has changed
-- @tparam number value The volume between 0 and 100
-- @staticfct emit_volume
-- @usage -- notify other components when the volume changed
-- lib-tde.signals.emit_volume(100)
connections.emit_volume = function(value)
    tde.emit_signal("volume::update", value)
end

--- Trigger a callback function when the volume changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_volume
-- @usage -- notify other components when the volume changed
-- lib-tde.signals.connect_volume(
--    function (value)
--      print("Current volume: " .. tostring(value))
--    end)
connections.connect_volume = function(func)
    tde.connect_signal("volume::update", func)
end

--- Notify other TDE components that the microphone volume changed
-- @tparam number value The volume between 0 and 100
-- @staticfct emit_mic_volume
-- @usage -- notify other components when the microphone volume changed
-- lib-tde.signals.emit_mic_volume(100)
connections.emit_mic_volume = function(value)
    tde.emit_signal("mic::volume::update", value)
end

--- Trigger a callback function when the microphone volume changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_mic_volume
-- @usage -- notify other components when the microphone volume changed
-- lib-tde.signals.connect_mic_volume(
--    function (value)
--      print("Current microphone volume: " .. tostring(value))
--    end)
connections.connect_mic_volume = function(func)
    tde.connect_signal("mic::volume::update", func)
end

--- Request an update to check to volume value
-- @staticfct emit_volume_update
-- @usage -- Notify that you changed the state of volume
-- lib-tde.signals.emit_volume_update()
connections.emit_volume_update = function(value)
    tde.emit_signal("volume::update::request", value or 0)
end

--- Trigger a callback function when a client requests a volume update
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_volume_update
-- @usage -- listen for clients that need the latest volume state
-- lib-tde.signals.connect_volume_update(
--    function ()
--      print("Request to search for latest volume state")
--    end)
connections.connect_volume_update = function(func)
    tde.connect_signal("volume::update::request", func)
end

--- Notify other TDE components that the volume mute state changed
-- @tparam bool value True if the volume is muted
-- @staticfct emit_volume_is_muted
-- @usage -- notify other components when the volume mute state changed
-- lib-tde.signals.emit_volume_is_muted(true)
connections.emit_volume_is_muted = function(value)
    tde.emit_signal("volume::update::muted", value)
end

--- Trigger a callback function when the volume mute state changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_volume_is_muted
-- @usage -- notify other components when the volume mute state changed
-- lib-tde.signals.connect_volume_is_muted(
--    function (isMuted)
--      print("Is volume enabled? " .. tostring(isMuted))
--    end)
connections.connect_volume_is_muted = function(func)
    tde.connect_signal("volume::update::muted", func)
end

--- Notify other TDE components that the volume should only be controlled from the hardware
-- @tparam bool bIsControlledInSoftware True if the volume is controlled in software
-- @staticfct emit_volume_is_controlled_in_software
-- @usage -- notify other components that software is allowed to control the volume
-- lib-tde.signals.emit_volume_is_controlled_in_software(true)
connections.emit_volume_is_controlled_in_software = function(bIsControlledInSoftware)
    tde.emit_signal("volume::controlled::software", bIsControlledInSoftware)
end

--- Trigger a callback function when the volume is controlled in software or not
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_volume_is_controlled_in_software
-- @usage -- notify other components when the volume software control state changed
-- lib-tde.signals.connect_volume_is_controlled_in_software(
--    function (bIsControlledInSoftware)
--      print("Is volume controlled in software? " .. tostring(bIsControlledInSoftware))
--    end)
connections.connect_volume_is_controlled_in_software = function(func)
    tde.connect_signal("volume::controlled::software", func)
end

--- Notify other TDE components that the weather updated
-- @tparam temp string The temperature in string representation
-- @tparam desc string A short description about the weather
-- @tparam icon string An icon code use to differentiate the weather
-- @staticfct emit_weather
-- @usage -- notify other components when the weather is updated
-- lib-tde.signals.emit_weather("14°C", "Cloudy with a change of meatballs", "99")
connections.emit_weather = function(temp, desc, icon)
    tde.emit_signal("widget::weather", temp, desc, icon)
end

--- Trigger a callback function when the weather info changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_weather
-- @usage -- notify other components when the weather is updated
-- lib-tde.signals.connect_weather(
--    function (temp, desc, icon)
--      print("Current temperature: " .. tostring(temp))
--      print("Current description: " .. tostring(desc))
--    end)
connections.connect_weather = function(func)
    tde.connect_signal("widget::weather", func)
end

--- Notify other TDE components that the username changed
-- @tparam string value The username
-- @staticfct emit_username
-- @usage -- notify other components when the user changed
-- lib-tde.signals.emit_user("user_1")
connections.emit_username = function(value)
    tde.emit_signal("user::changed", value)
end

--- Trigger a callback function when the user changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_username
-- @usage -- notify other components when the user changed
-- lib-tde.signals.connect_username(
--    function (value)
--      print("Current user: " .. value)
--    end)
connections.connect_username = function(func)
    tde.connect_signal("user::changed", func)
end

---Request the user data
-- @staticfct emit_request_user
-- @see connect_username
-- @usage -- notify other components that you want to know the user data
-- lib-tde.signals.emit_request_user()
connections.emit_request_user = function()
    tde.emit_signal("user::request", true)
end

--- Trigger a callback function some end users want's to know the user data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_user
-- @usage
-- lib-tde.signals.connect_request_user(
--    function ()
--      print("Someone wants to know the user data")
--    end)
connections.connect_request_user = function(func)
    tde.connect_signal("user::request", func)
end

--- Notify other TDE components that the distro name changed
-- @tparam string value The distribution name
-- @staticfct emit_distro
-- @usage -- notify other components when the distro changed
-- lib-tde.signals.emit_distro("TOS Linux")
connections.emit_distro = function(value)
    tde.emit_signal("distro::changed", value)
end

--- Trigger a callback function when the distro changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_distro
-- @usage -- notify other components when the distro changed
-- lib-tde.signals.connect_distro(
--    function (value)
--      print("Current distro: " .. value)
--    end)
connections.connect_distro = function(func)
    tde.connect_signal("distro::changed", func)
end

---Request the distro data
-- @staticfct emit_request_distro
-- @see connect_distro
-- @usage -- notify other components that you want to know the distor data
-- lib-tde.signals.emit_request_distro()
connections.emit_request_distro = function()
    tde.emit_signal("distro::request", true)
end

--- Trigger a callback function some end users want's to know the distro data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_distro
-- @usage
-- lib-tde.signals.connect_request_distro(
--    function ()
--      print("Someone wants to know the distro data")
--    end)
connections.connect_request_distro = function(func)
    tde.connect_signal("distro::request", func)
end

--- Notify other TDE components that the uptime changed
-- @tparam string value The uptime
-- @staticfct emit_uptime
-- @usage -- notify other components when the uptime changed
-- lib-tde.signals.emit_uptime("10 seconds")
connections.emit_uptime = function(value)
    tde.emit_signal("uptime::changed", value)
end

--- Trigger a callback function when the uptime changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_uptime
-- @usage -- notify other components when the uptime changed
-- lib-tde.signals.connect_uptime(
--    function (value)
--      print("Current uptime: " .. value)
--    end)
connections.connect_uptime = function(func)
    tde.connect_signal("uptime::changed", func)
end

---Request the uptime data
-- @staticfct emit_request_uptime
-- @see connect_uptime
-- @usage -- notify other components that you want to know the uptime
-- lib-tde.signals.emit_request_uptime()
connections.emit_request_uptime = function()
    tde.emit_signal("uptime::request", true)
end

--- Trigger a callback function some end users want's to know the uptime data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_uptime
-- @usage
-- lib-tde.signals.connect_request_uptime(
--    function ()
--      print("Someone wants to know the uptime data")
--    end)
connections.connect_request_uptime = function(func)
    tde.connect_signal("uptime::request", func)
end

--- Notify other TDE components what the current kernel version is
-- @tparam string value The kernel version
-- @staticfct emit_kernel
-- @usage -- notify other components what the current kernel is
-- lib-tde.signals.emit_kernel("v5.0.0-tos1")
connections.emit_kernel = function(value)
    tde.emit_signal("kernel::changed", value)
end

--- Trigger a callback function when the kernel changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_kernel
-- @usage -- notify other components when the kernel changed
-- lib-tde.signals.connect_kernel(
--    function (value)
--      print("Current kernel: " .. value)
--    end)
connections.connect_kernel = function(func)
    tde.connect_signal("kernel::changed", func)
end

---Request the kernel data
-- @staticfct emit_request_kernel
-- @see connect_kernel
-- @usage -- notify other components that you want to know the kernel data
-- lib-tde.signals.emit_request_kernel()
connections.emit_request_kernel = function()
    tde.emit_signal("kernel::request", true)
end

--- Trigger a callback function some end users want's to know the kernel data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_kernel
-- @usage
-- lib-tde.signals.connect_request_kernel(
--    function ()
--      print("Someone wants to know the kernel data")
--    end)
connections.connect_request_kernel = function(func)
    tde.connect_signal("kernel::request", func)
end

--- Notify other TDE components how many packages should be updated
-- @tparam string value The amount of updates
-- @staticfct emit_packages_to_update
-- @usage -- notify other components how much packages need to be updated
-- lib-tde.signals.emit_kernel("7")
connections.emit_packages_to_update = function(value)
    tde.emit_signal("packages::changed:update", value)
end

--- Trigger a callback function when packages to update changed
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_packages_to_update
-- @usage -- notify other components when system packages need updates
-- lib-tde.signals.connect_packages_to_update(
--    function (value)
--      print("Packages to update: " .. value)
--    end)
connections.connect_packages_to_update = function(func)
    tde.connect_signal("packages::changed:update", func)
end

--- Notify other TDE components about the current cpu usage
-- @tparam number value The current cpu usage in percentage
-- @staticfct emit_cpu_usage
-- @usage -- notify other components of the current cpu usage
-- lib-tde.signals.emit_cpu_usage("32")
connections.emit_cpu_usage = function(value)
    tde.emit_signal("cpu::usage", value)
end

--- Trigger a callback function when the cpu usage has been updated
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_cpu_usage
-- @usage -- notify other components when cpu usage changed
-- lib-tde.signals.connect_cpu_usage(
--    function (value)
--      print("CPU usage: " .. tostring(value) .. "%")
--    end)
connections.connect_cpu_usage = function(func)
    tde.connect_signal("cpu::usage", func)
end

---Request the cpu data
-- @staticfct emit_request_cpu
-- @see connect_cpu_usage
-- @usage -- notify other components that you want to know the cpu data
-- lib-tde.signals.emit_request_cpu()
connections.emit_request_cpu = function()
    tde.emit_signal("cpu::request", true)
end

--- Trigger a callback function some end users want's to know the cpu data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_cpu
-- @usage
-- lib-tde.signals.connect_request_cpu(
--    function ()
--      print("Someone wants to know the cpu usage")
--    end)
connections.connect_request_cpu = function(func)
    tde.connect_signal("cpu::request", func)
end

--- Notify other TDE components about the current disk usage
-- @tparam number value The current disk usage in percentage
-- @staticfct emit_disk_usage
-- @usage -- notify other components of the current disk usage
-- lib-tde.signals.emit_disk_usage("32")
connections.emit_disk_usage = function(value)
    tde.emit_signal("disk::usage", value)
end

--- Trigger a callback function when the disk usage has been updated
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_disk_usage
-- @usage -- notify other components when disk usage changed
-- lib-tde.signals.connect_disk_usage(
--    function (value)
--      print("DISK usage: " .. tostring(value) .. "%")
--    end)
connections.connect_disk_usage = function(func)
    tde.connect_signal("disk::usage", func)
end

---Request the disk data
-- @staticfct emit_request_disk
-- @see connect_disk_usage
-- @usage -- notify other components that you want to know the disk data
-- lib-tde.signals.emit_request_disk()
connections.emit_request_disk = function()
    tde.emit_signal("disk::request", true)
end

--- Trigger a callback function some end users want's to know the disk data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_disk
-- @usage
-- lib-tde.signals.connect_request_disk(
--    function ()
--      print("Someone wants to know the disk usage")
--    end)
connections.connect_request_disk = function(func)
    tde.connect_signal("disk::request", func)
end

--- Notify other TDE components about the total disk space
-- @tparam string value The current total disk space in percentage
-- @staticfct emit_disk_space
-- @usage -- notify other components of the total disk space
-- lib-tde.signals.emit_disk_space("467G")
connections.emit_disk_space = function(value)
    tde.emit_signal("disk::space", value)
end

--- Trigger a callback function when the disk space has been updated
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_disk_space
-- @usage -- notify other components when disk space changed
-- lib-tde.signals.connect_disk_space(
--    function (value)
--      print("DISK space: " .. tostring(value) .. "%")
--    end)
connections.connect_disk_space = function(func)
    tde.connect_signal("disk::space", func)
end

--- Notify other TDE components about the current ram usage
-- @tparam number value The current ram usage in percentage
-- @staticfct emit_ram_usage
-- @usage -- notify other components of the current ram usage
-- lib-tde.signals.emit_ram_usage("32")
connections.emit_ram_usage = function(value)
    tde.emit_signal("ram::usage", value)
end

--- Trigger a callback function when the ram usage has been updated
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_ram_usage
-- @usage -- notify other components when ram usage changed
-- lib-tde.signals.connect_ram_usage(
--    function (value)
--      print("RAM usage: " .. tostring(value) .. "%")
--    end)
connections.connect_ram_usage = function(func)
    tde.connect_signal("ram::usage", func)
end

--- Notify other TDE components about the total ram
-- @tparam string value The total ram available on the system in kilobytes
-- @staticfct emit_ram_total
-- @usage -- notify other components of the total ram in kilobytes
-- lib-tde.signals.emit_ram_total("14000000")
connections.emit_ram_total = function(value)
    tde.emit_signal("ram::total", value)
end

--- Trigger a callback function for the total ram amount
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_ram_total
-- @usage -- notify other components when total ram changed
-- lib-tde.signals.connect_ram_total(
--    function (value)
--      print("RAM total: " .. tostring(value) .. "%")
--    end)
connections.connect_ram_total = function(func)
    tde.connect_signal("ram::total", func)
end

---Request the ram data
-- @staticfct emit_request_ram
-- @see connect_ram_usage
-- @usage -- notify other components that you want to know the ram data
-- lib-tde.signals.emit_request_ram()
connections.emit_request_ram = function()
    tde.emit_signal("ram::request", true)
end

--- Trigger a callback function some end users want's to know the ram data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_ram
-- @usage
-- lib-tde.signals.connect_request_ram(
--    function ()
--      print("Someone wants to know the ram data")
--    end)
connections.connect_request_ram = function(func)
    tde.connect_signal("ram::request", func)
end

--- Notify other TDE components about the current bluetooth status
-- @tparam boolean value If bluetooth is on or off
-- @staticfct emit_bluetooth_status
-- @usage -- Notify other TDE components about the current bluetooth status
-- lib-tde.signals.emit_bluetooth_status(true)
connections.emit_bluetooth_status = function(value)
    tde.emit_signal("BLUETOOTH::status", value)
end

--- Trigger a callback function for the current bluetooth status
-- @tparam function func The callback function that will be called when the bluetooth status changes
-- @staticfct connect_bluetooth_status
-- @usage -- notify other components when bluetooth status changes
-- lib-tde.signals.connect_bluetooth_status(
--    function (value)
--      print("Bluetooth active?: " .. tostring(value))
--    end)
connections.connect_bluetooth_status = function(func)
    tde.connect_signal("BLUETOOTH::status", func)
end

--- Notify other TDE components about the current wifi status
-- @tparam boolean value If wifi is on or off
-- @staticfct emit_wifi_status
-- @usage -- Notify other TDE components about the current wifi status
-- lib-tde.signals.emit_wifi_status(true)
connections.emit_wifi_status = function(value)
    tde.emit_signal("WIFI::status", value)
end

--- Trigger a callback function for the current wifi status
-- @tparam function func The callback function that will be called when the bluetooth status changes
-- @staticfct connect_wifi_status
-- @usage -- notify other components when wifi status changes
-- lib-tde.signals.connect_wifi_status(
--    function (value)
--      print("Wifi active?: " .. tostring(value))
--    end)
connections.connect_wifi_status = function(func)
    tde.connect_signal("WIFI::status", func)
end

--- Trigger a callback function when we are about to shut down
-- @tparam function func The callback function that will be called when we are shutting down
-- @staticfct connect_exit
-- @usage -- this function will be called when shutting down
-- lib-tde.signals.connect_exit(
--    function ()
--      print("Goodbye")
--    end)
connections.connect_exit = function(func)
    tde.connect_signal("exit", func)
end

--- Notify other TDE components about the change in mouse acceleration
-- @tparam table the mouse id and speed value
-- @staticfct emit_mouse_acceleration
-- @usage -- Notify other TDE components about the change in mouse acceleration
-- lib-tde.signals.emit_mouse_acceleration({id: 11, speed: 1.5})
connections.emit_mouse_acceleration = function(value)
    tde.emit_signal("TDE::mouse::acceleration", value)
end

--- Trigger a callback function when the mouse acceleration changed
-- @tparam function func The callback function that will be called when the mouse acceleration changed
-- @staticfct connect_mouse_acceleration
-- @usage -- notify other components when the mouse acceleration changed
-- lib-tde.signals.connect_mouse_acceleration(
--    function (value)
--      print("Mouse acceleration settings: " .. value.id .. " with speed:" .. value.speed)
--    end)
connections.connect_mouse_acceleration = function(func)
    tde.connect_signal("TDE::mouse::acceleration", func)
end

--- Notify other TDE components about the change in mouse speed
-- @tparam table the mouse id and speed value
-- @staticfct emit_mouse_speed
-- @usage -- Notify other TDE components about the change in mouse speed
-- lib-tde.signals.emit_mouse_speed({id: 11, speed: 1.5})
connections.emit_mouse_speed = function(value)
    tde.emit_signal("TDE::mouse::speed", value)
end

--- Trigger a callback function when the mouse speed changed
-- @tparam function func The callback function that will be called when the mouse speed changed
-- @staticfct connect_mouse_speed
-- @usage -- notify other components when the mouse speed changed
-- lib-tde.signals.connect_mouse_speed(
--    function (value)
--      print("Mouse speed settings: " .. value.id .. " with speed:" .. value.speed)
--    end)
connections.connect_mouse_speed = function(func)
    tde.connect_signal("TDE::mouse::speed", func)
end

--- Notify other TDE components about the change in mouse natural scrolling
-- @tparam table the mouse id and natural scrolling state
-- @staticfct emit_mouse_natural_scrolling
-- @usage -- Notify other TDE components about the change in mouse natural scrolling state
-- lib-tde.signals.emit_mouse_speed({id: 11, state: true})
connections.emit_mouse_natural_scrolling = function(value)
    tde.emit_signal("TDE::mouse::natural_scrolling", value)
end

--- Trigger a callback function when the mouse natural scrolling state changed
-- @tparam function func The callback function that will be called when the mouse natural scrolling state changed
-- @staticfct connect_mouse_natural_scrolling
-- @usage -- notify other components when the mouse natural scrolling state changed
-- lib-tde.signals.connect_mouse_natural_scrolling(
--    function (value)
--      print("Mouse natural scrolling state settings: " .. value.id .. " with state:" .. value.state)
--    end)
connections.connect_mouse_natural_scrolling = function(func)
    tde.connect_signal("TDE::mouse::natural_scrolling", func)
end

--- Notify wiboxes when the screen layout is updated (so they can update their position)
-- @staticfct emit_refresh_screen
-- @usage -- Notify other TDE components about the screen update
-- lib-tde.signals.emit_refresh_screen()
connections.emit_refresh_screen = function()
    tde.emit_signal("TDE::screen:refresh")
end

--- Trigger a callback function when a wibox should update their position on the screen
-- @tparam function func The callback function that will be called when the screen geometry changed
-- @staticfct connect_refresh_screen
-- @usage --
-- lib-tde.signals.connect_refresh_screen(
--    function ()
--      print("Some screen updated")
--    end)
connections.connect_refresh_screen = function(func)
    tde.connect_signal("TDE::screen:refresh", func)
end

--- Notify when the user profile picture changed
-- @tparam string picture The profile picture file path
-- @staticfct emit_profile_picture_changed
-- @usage -- Notify other TDE components when the user profile picture changed
-- lib-tde.signals.emit_profile_picture_changed()
connections.emit_profile_picture_changed = function(picture)
    tde.emit_signal("TDE::profile:picture::changed", picture)
end

--- Trigger a callback function when the user profile picture changed
-- @tparam function func The callback function that will be called when the user profile picture changed
-- @staticfct profile_picture_changed
-- @usage --
-- lib-tde.signals.profile_picture_changed(
--    function (picture)
--      print("Changed profile picture to: " .. picture)
--    end)
connections.connect_profile_picture_changed = function(func)
    tde.connect_signal("TDE::profile:picture::changed", func)
end

---Request the user data
-- @staticfct emit_request_profile_pic
-- @see connect_profile_picture_changed
-- @usage -- notify other components that you want to know the profile data
-- lib-tde.signals.emit_request_profile_pic()
connections.emit_request_profile_pic = function()
    tde.emit_signal("profile::pic::request", true)
end

--- Trigger a callback function some end users want's to know the profile picture data
-- @tparam function func The callback function that will be called when the event happens
-- @staticfct connect_request_profile_pic
-- @usage
-- lib-tde.signals.connect_request_profile_pic(
--    function ()
--      print("Someone wants to know the profile picture data")
--    end)
connections.connect_request_profile_pic = function(func)
    tde.connect_signal("profile::pic::request", func)
end

--- Notify when the notification disturb state changes
-- @tparam bool bDoNotDisturb If Do Not Disturb mode is turned on
-- @staticfct emit_do_not_disturb
-- @usage -- Notify other TDE components what the current do not disturb mode is
-- lib-tde.signals.emit_do_not_disturb()
connections.emit_do_not_disturb = function(bDoNotDisturb)
    tde.emit_signal("TDE::do_not_disturb::changed", bDoNotDisturb)
end

--- Trigger a callback function when the do not disturb mode changed
-- @tparam function func The callback function that will be called when the do not disturb mode changed
-- @staticfct connect_do_not_disturb
-- @usage --
-- lib-tde.signals.connect_do_not_disturb(
--    function (bDoNotDisturb)
--      print("Do not disturb mode: " .. tostring(bDoNotDisturb))
--    end)
connections.connect_do_not_disturb = function(func)
    tde.connect_signal("TDE::do_not_disturb::changed", func)
end

--- Notify when the primary theme changed
-- @tparam table theme The new theme pallet
-- @staticfct emit_primary_theme_changed
-- @usage -- Notify other TDE components that the primary theme changed
-- lib-tde.signals.emit_primary_theme_changed()
connections.emit_primary_theme_changed = function(pallet)
    setmetatable(pallet, weak)
    tde.emit_signal("TDE::primary::theme::changed", pallet)
end

--- Trigger a callback function when the primary theme changed
-- @tparam function func The callback function that will be called when the primary theme changed
-- @staticfct connect_primary_theme_changed
-- @usage --
-- lib-tde.signals.connect_primary_theme_changed(
--    function (theme)
--      print("The hue_600 color of this theme: " .. theme.hue_600)
--    end)
connections.connect_primary_theme_changed = function(func)
    tde.connect_signal("TDE::primary::theme::changed", func)
end

--- Notify when the background theme changed
-- @tparam table theme The new theme pallet
-- @staticfct emit_background_theme_changed
-- @usage -- Notify other TDE components that the background theme changed
-- lib-tde.signals.emit_background_theme_changed()
connections.emit_background_theme_changed = function(pallet)
    setmetatable(pallet, weak)
    tde.emit_signal("TDE::background::theme::changed", pallet)
end

--- Trigger a callback function when the background theme changed
-- @tparam function func The callback function that will be called when the background theme changed
-- @staticfct connect_background_theme_changed
-- @usage --
-- lib-tde.signals.connect_background_theme_changed(
--    function (theme)
--      print("The hue_600 color of this theme: " .. theme.hue_600)
--    end)
connections.connect_background_theme_changed = function(func)
    tde.connect_signal("TDE::background::theme::changed", func)
end

--- Notify when the oled brightness mode changed
-- @tparam bool bIsOledMode True if oled mode is enabled
-- @staticfct emit_oled_mode
-- @usage -- Notify other TDE components that the oled brightness mode changed
-- lib-tde.signals.emit_oled_mode(true)
connections.emit_oled_mode = function(bIsOledMode)
    tde.emit_signal("TDE::oled::mode::changed", bIsOledMode)
end

--- Trigger a callback function when the oled brightness mode changed
-- @tparam function func The callback function that will be called when the oled brightness mode changed
-- @staticfct connect_oled_mode
-- @usage --
-- lib-tde.signals.connect_oled_mode(
--    function (bIsOledMode)
--      print("Is oled mode enabled?: " .. tostring(bIsOledMode))
--    end)
connections.connect_oled_mode = function(func)
    tde.connect_signal("TDE::oled::mode::changed", func)
end


--- Notify when the anchor type changed of the panels (Bottom, left, right)
-- @tparam string anchor The new anchor location Can either be (bottom, left or right)
-- @staticfct emit_anchor_changed
-- @usage -- Notify other TDE components that the screen panel should change
-- lib-tde.signals.emit_anchor_changed("bottom")
connections.emit_anchor_changed = function(anchor)
    tde.emit_signal("TDE::tag::anchor::changed", anchor)
end

--- Trigger a callback function when the anchor type changed of the panels (Bottom, left, right)
-- @tparam function func The callback function that will be called when the anchor changes
-- @staticfct connect_anchor_changed
-- @usage --
-- lib-tde.signals.connect_anchor_changed(
--    function (value)
--      print("Changing anchor to: " .. value)
--    end)
connections.connect_anchor_changed = function(func)
    tde.connect_signal("TDE::tag::anchor::changed", func)
end

--- Notify when we should save the tag state
-- @staticfct emit_save_tag_state
-- @usage -- Notify other TDE components that the tag state should be saved
-- lib-tde.signals.emit_save_tag_state()
connections.emit_save_tag_state = function()
    tde.emit_signal("TDE::tag::save::state")
end

--- Trigger a callback function when the tag data has changed
-- @tparam function func The callback function that will be called when the tag data changed
-- @staticfct connect_save_tag_state
-- @usage --
-- lib-tde.signals.connect_save_tag_state(
--    function ()
--      print("Saving the tag state")
--    end)
connections.connect_save_tag_state = function(func)
    tde.connect_signal("TDE::tag::save::state", func)
end

--- Notify when the auto_hide property has changed of the wiboxes
-- @tparam boolean bIsEnabled If the auto hiding is enabled
-- @staticfct emit_auto_hide
-- @usage -- Notify other TDE components that the auto hiding property of the wiboxes has changed
-- lib-tde.signals.emit_auto_hide("bottom")
connections.emit_auto_hide = function(bIsEnabled)
    tde.emit_signal("TDE::auto_hide::changed", bIsEnabled)
end

--- Trigger a callback function when the auto_hide property has changed of the wiboxes
-- @tparam function func The callback function that will be called when the auto_hide changes
-- @staticfct connect_auto_hide
-- @usage --
-- lib-tde.signals.connect_auto_hide(
--    function (value)
--      print("Current auto hiding status: " .. tostring(value))
--    end)
connections.connect_auto_hide = function(func)
    tde.connect_signal("TDE::auto_hide::changed", func)
end

--- Notify TDE components that the latest news has been showed
-- @staticfct emit_showed_news
-- @usage
-- lib-tde.signals.emit_showed_news()
connections.emit_showed_news = function()
    tde.emit_signal("TDE::update::news::showed")
end

--- Trigger a callback function the updated news has been shown
-- @tparam function func The callback function that will be called when the update news has been shown
-- @staticfct connect_showed_news
-- @usage
-- lib-tde.signals.connect_showed_news(
--    function ()
--      print("The user has seen the latest updates")
--    end)
connections.connect_showed_news = function(func)
    tde.connect_signal("TDE::update::news::showed", func)
end

--- Notify TDE components that the titlebar state should change
-- @tparam bool bShouldDraw If we should draw the titlebar or not
-- @staticfct emit_titlebar_redraw
-- @usage
-- lib-tde.signals.emit_titlebar_redraw()
connections.emit_titlebar_redraw = function(bShouldDraw)
    tde.emit_signal("TDE::update::news::showed", bShouldDraw)
end

--- Trigger a callback function that the titlebar drawing changed
-- @tparam function func The callback function that will be called when the titlebar state changed
-- @staticfct connect_titlebar_redraw
-- @usage
-- lib-tde.signals.connect_titlebar_redraw(
--    function (draw)
--      print("Will we draw the titlebars: " .. draw)
--    end)
connections.connect_titlebar_redraw = function(func)
    tde.connect_signal("TDE::update::news::showed", func)
end

--- Signals to notify to move to the next layout of the keyboards
-- @staticfct emit_keyboard_layout
-- @usage
-- lib-tde.signals.emit_keyboard_layout()
connections.emit_keyboard_layout = function()
    tde.emit_signal("TDE::keyboard::layout::next")
end

--- Trigger a callback function to change to the next keyboard layout
-- @tparam function func The callback function that will be called when the keyboard layout should change
-- @staticfct connect_keyboard_layout
-- @usage
-- lib-tde.signals.connect_keyboard_layout(
--    function ()
--      print("Changing to the next layout")
--    end)
connections.connect_keyboard_layout = function(func)
    tde.connect_signal("TDE::keyboard::layout::next", func)
end

--- Signals to notify that the keyboard layout has changed
-- @staticfct emit_keyboard_layout_updated
-- @usage
-- lib-tde.signals.emit_keyboard_layout_updated({'us', 'be', 'ru'}, 'us')
connections.emit_keyboard_layout_updated = function(layouts, active)
    tde.emit_signal("TDE::keyboard::layout::updated", layouts, active)
end

--- Trigger a callback function to change to the next keyboard layout
-- @tparam function func The callback function that will be called when the keyboard layout should change
-- @staticfct connect_keyboard_layout_updated
-- @usage
-- lib-tde.signals.connect_keyboard_layout_updated(
--    function (layouts, active)
--      print("Changing to the next layout was succesfull")
--    end)
connections.connect_keyboard_layout_updated = function(func)
    tde.connect_signal("TDE::keyboard::layout::updated", func)
end

--- Signals to notify that the developer settings should be saved
-- @staticfct emit_save_developer_settings
-- @usage
-- lib-tde.signals.emit_save_developer_settings()
connections.emit_save_developer_settings = function(layouts, active)
    tde.emit_signal("TDE::save::developer::settings", layouts, active)
end

--- Trigger a callback function to save the current developer settings
-- @tparam function func The callback function that will be called
-- @staticfct connect_save_developer_settings
-- @usage
-- lib-tde.signals.connect_save_developer_settings(
--    function ()
--      print("Saving developer settings")
--    end)
connections.connect_save_developer_settings = function(func)
    tde.connect_signal("TDE::save::developer::settings", func)
end

--- Signals to notify that the theming settings should be saved
-- @tparam bool bIsPrimaryGradient If we should save the primary color pallet
-- @tparam bool bIsBackgroundGradient If we should save the background color pallet
-- @staticfct emit_save_theming_settings
-- @usage
-- lib-tde.signals.emit_save_theming_settings()
connections.emit_save_theming_settings = function(bIsPrimaryGradient, bIsBackgroundGradient)
    tde.emit_signal("TDE::save::theming::settings", bIsPrimaryGradient, bIsBackgroundGradient)
end

--- Trigger a callback function to save the current theming settings
-- @tparam function func The callback function that will be called
-- @staticfct connect_save_theming_settings
-- @usage
-- lib-tde.signals.connect_save_theming_settings(
--    function ()
--      print("Saving theming settings")
--    end)
connections.connect_save_theming_settings = function(func)
    tde.connect_signal("TDE::save::theming::settings", func)
end

--- Signals to notify that we want to make a plugin appear in a given location
-- @tparam string location If we should save the primary color pallet
-- @tparam widget plugin The plugin we wish to load in on that location
-- @staticfct emit_add_plugin
-- @usage
-- lib-tde.signals.emit_add_plugin()
connections.emit_add_plugin = function(location, plugin)
    tde.emit_signal("TDE::add_plugin", location, plugin)
end

--- Trigger a callback function to add a plugin to your location
-- @tparam function func The callback function that will be called
-- @staticfct connect_add_plugin
-- @usage
-- lib-tde.signals.connect_add_plugin(
--    function (location, plugin)
--      if location == "your_location" then
--          print("Adding plugin: " .. tostring(plugin))
--      end
--    end)
connections.connect_add_plugin = function(func)
    tde.connect_signal("TDE::add_plugin", func)
end

--- Signals to notify that the rounded corners should change
-- @tparam number dpi The amount of pixels (radius) that the corner should have
-- @staticfct emit_change_rounded_corner_dpi
-- @usage
-- lib-tde.signals.emit_change_rounded_corner_dpi(dpi(10))
connections.emit_change_rounded_corner_dpi = function(dpi)
    tde.emit_signal("TDE::change::rounded::corners", dpi)
end

--- Trigger a callback function when the rounded corner should change
-- @tparam function func The callback function that will be called
-- @staticfct connect_change_rounded_corner_dpi
-- @usage
-- lib-tde.signals.connect_change_rounded_corner_dpi(
--    function (radius)
--     print("The new corner radius: " .. tostring(radius))
--    end)
connections.connect_change_rounded_corner_dpi = function(func)
    tde.connect_signal("TDE::change::rounded::corners", func)
end

--- Signals to notify that the we should cycle multiple wallpapers
-- @tparam bool bIsEnabled If we should show one wallpaper or multiple
-- @tparam table wallpapers A list of a table in the form {hour, image}
-- @staticfct emit_enable_wallpaper_changer
-- @usage
-- lib-tde.signals.emit_enable_wallpaper_changer(true, {{hour = 12, image = "/path/to/wallpaper.png"}, {hour = 0, image = "/path/to/wallpaper_2.png"}})
connections.emit_enable_wallpaper_changer = function(bIsEnabled, wallpapers, default)
    tde.emit_signal("TDE::change::wallpaper::mode", bIsEnabled, wallpapers, default)
end

--- Trigger a callback function when the wallpaper mode changed
-- @tparam function func The callback function that will be called
-- @staticfct connect_enable_wallpaper_changer
-- @usage
-- lib-tde.signals.connect_enable_wallpaper_changer(
--    function (bIsEnabled, wallpapers)
--     print("Is the wallpaper enabled? " .. bIsEnabled)
--     print(wallpapers)
--    end)
connections.connect_enable_wallpaper_changer = function(func)
    tde.connect_signal("TDE::change::wallpaper::mode", func)
end

--- Signals to notify that the we should update the vpn data
-- @tparam table vpns The metadata about the vpn
-- @staticfct emit_vpn_connection_data
-- @usage
-- lib-tde.signals.emit_vpn_connection_data({ovpn_file: '/path/to/openvpn/file.ovpn', username: "name_of_the_user", password: 'password_of_the_user'})
connections.emit_vpn_connection_data = function(vpns)
    tde.emit_signal("TDE::update::vpn::data", vpns)
end

--- Trigger a callback function when extra openvpn data should be stored
-- @tparam function func The callback function that will be called
-- @staticfct connect_vpn_connection_data
-- @usage
-- lib-tde.signals.connect_vpn_connection_data(
--    function (vpn)
--     print("Extra vpn data found")
--     print(vpn)
--    end)
connections.connect_vpn_connection_data = function(func)
    tde.connect_signal("TDE::update::vpn::data", func)
end

--- Signals to notify that the we should update the plugin data
-- @tparam table plugins The metadata about the plugins
-- @staticfct emit_save_plugins
-- @usage
-- lib-tde.signals.emit_save_plugins({active = false, name = "example-plugin", metadata = {type = "module"}})
connections.emit_save_plugins = function(plugins)
    tde.emit_signal("TDE::update::plugin::data", plugins)
end

--- Trigger a callback function when extra plugin data should be stored
-- @tparam function func The callback function that will be called
-- @staticfct connect_save_plugins
-- @usage
-- lib-tde.signals.connect_save_plugins(
--    function (plugins)
--     print("Extra plugin data found")
--     print(plugins)
--    end)
connections.connect_save_plugins = function(func)
    tde.connect_signal("TDE::update::plugin::data", func)
end

--- Signals to notify that we should change the default monitor refresh rate and resolution
-- @tparam string monitor_id The unique id of the monitor being connected
-- @tparam string resolution The resolution that the monitor should opperate at
-- @tparam number refresh_rate The refresh rate in Hz
-- @staticfct emit_save_display_settings
-- @usage
-- lib-tde.signals.emit_save_display_settings("eDP1", "1920x1080", 60)
connections.emit_save_display_settings = function(monitor_id, resolution, refresh_rate)
    tde.emit_signal("TDE::monitor::save:settings", monitor_id, resolution, refresh_rate)
end

--- Trigger a callback function when we should change the default resolution and refresh rate
-- @tparam function func The callback function that will be called
-- @staticfct connect_save_display_settings
-- @usage
-- lib-tde.signals.connect_save_display_settings(
--    function (id, resolution, refresh_rate)
--     print("Updating default settings for: " .. id)
--     print(resolution)
--     print(refresh_rate)
--    end)
connections.connect_save_display_settings = function(func)
    tde.connect_signal("TDE::monitor::save:settings", func)
end

return connections
