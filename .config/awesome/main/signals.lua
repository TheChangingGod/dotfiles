-- main.signals.lua
local gears = require("gears")
local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")
local menubar = require("menubar")

-- Reload theme from Pywal JSON
awesome.connect_signal("reload_theme", function()
    if beautiful.reload_pywal then
        beautiful.reload_pywal()
    else
        naughty.notify({
            title = "Theme Reload",
            text = "No reload_pywal function found."
        })
        return
    end

    -- Update all screens
    for s in screen do
        -- Update wallpaper
        if s.wallpaper then
            if type(s.wallpaper) == "function" then
                s.wallpaper = s.wallpaper(s)
            end
            gears.wallpaper.maximized(s.wallpaper, s, true)
        end

        -- Update wibar backgrounds
        if s.mywibox then
            s.mywibox.bg = beautiful.bg_normal
        end

        -- Update taglist
        if s.mytaglist then
            for _, t in ipairs(s.tags) do
                t:emit_signal("property::selected")
            end
        end

        -- Update tasklist
        if s.mytasklist then
            for _, c in ipairs(client.get()) do
                c:emit_signal("property::urgent")
                c:emit_signal("property::minimized")
                c:emit_signal("property::focused")
            end
        end
    end

    naughty.notify({
        title = "Theme Reload",
        text = "Pywal colors applied!"
    })
end)

-- {{{ Titlebars
-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
   -- awful.titlebar.hide(c)
end)
-- }}}


-- Function to set icon by advanced business logic
local set_client_icon = function(c)
    local icon = nil
    local lower_icon = nil

    -- Check if c.instance exists before calling menubar.utils.lookup_icon
    if c.instance then
        icon = menubar.utils.lookup_icon(c.instance)
        lower_icon = menubar.utils.lookup_icon(c.instance:lower())
    end

    -- Check if the icon exists
    if icon ~= nil then
        local new_icon = gears.surface(icon)
        c.icon = new_icon._native

    -- Check if the lowercase icon exists
    elseif lower_icon ~= nil then
        local new_icon = gears.surface(lower_icon)
        c.icon = new_icon._native

    -- If the client already has an icon. If not, give it a default
    elseif c.icon == nil then
        local default_icon = menubar.utils.lookup_icon("application-default-icon")
        if default_icon then
            local new_icon = gears.surface(default_icon)
            c.icon = new_icon._native
        end
    end
end

client.connect_signal("manage", function(c)
    -- Search the application icons by advanced logic
    set_client_icon(c)

    -- Similar behaviour as other window managers DWM, XMonad.
    -- Master-Slave layout: new client goes to the slave, master is kept
    -- If you need new slave as master press: ctrl + super + return
    if not awesome.startup then
        c:to_secondary_section()
    end
end)



-- {{{ Focusing
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)
-- }}}
