-- appearance/widgets.lua
local wibox     = require("wibox")
local beautiful = require("beautiful")
local vars      = require("main.user_variables")
local awful     = require("awful")
local gears     = require("gears")

-- ======================
-- Timers / Signals
-- ======================


-- ============
-- Volume: realtime updates via pactl subscribe
-- ============

-- Parse wpctl output like: "Volume: 0.56" or "Volume: 0.56 [MUTED]"
local function parse_wpctl_volume(stdout)
    if not stdout or stdout == "" then return end
    local num = stdout:match("([%d%.]+)")
    if not num then return end
    local level = math.floor(tonumber(num) * 100 + 0.5)
    local muted = stdout:find("MUTED") ~= nil
    return level, muted
end

local function emit_current_volume()
    awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(out)
        local level, muted = parse_wpctl_volume(out)
        if level then
            awesome.emit_signal("laptop::volume", level, muted and "M" or "U")
        end
    end)
end

-- Initial emit so the widget shows something on startup
emit_current_volume()

-- Subscribe to sink/server changes (works with pipewire-pulse and PulseAudio)
awful.spawn.with_line_callback("pactl subscribe", {
    stdout = function(line)
        if line:find("on sink") or line:find("on server") then
            emit_current_volume()
        end
    end
})

-- Optional: fallback polling if pactl isn't available
-- gears.timer {
--     timeout = 2,
--     autostart = true,
--     call_now = false,
--     callback = emit_current_volume,
-- }


-- Battery info updater
gears.timer {
    timeout   = 60,
    call_now  = true,
    autostart = true,
    callback  = function()
        awful.spawn.easy_async_with_shell("acpi", function(stdout)
            local value = string.match(stdout, "%d+%%")
            if value and value ~= "" then
                awesome.emit_signal("laptop::battery", value)
            end
        end)
    end
}

-- System tray icon spacing
beautiful.systray_icon_spacing = vars.dpi(5)

-- ======================
-- Widget registration
-- ======================

local widgets = {}
widgets.__order = {}

local function add_widget(name, value, side)
    widgets[name] = value
    table.insert(widgets.__order, { name = name, side = side })
end

-- ======================
-- Actual Widgets
-- ======================

-- Keyboard layout
add_widget("mykeyboardlayout", awful.widget.keyboardlayout(), "right")

-- Praise widget (static text)
add_widget("praisewidget", wibox.widget.textbox("You are great!"), "left")

-- Clock
add_widget("mytextclock", function(s)
    return wibox.widget {
        widget = wibox.widget.textclock,
        screen = s,
    }
end, "right")


-- Volume Widget
local function get_volume_icon(level, muted)
    local icon_path = os.getenv("HOME") .. "/.config/awesome/themes/pywal/icons/"
    if muted then
        return icon_path .. "vol_mute.png"
    elseif level <= 30 then
        return icon_path .. "vol_low.png"
    else
        return icon_path .. "vol.png"
    end
end

add_widget("myvolume", function(s)
      local ICON_SIZE = vars.dpi(20)  -- pick what you like: 18, 20, 22...

    local vol_icon = wibox.widget {
        widget = wibox.widget.imagebox,
        resize = true,
        forced_width  = ICON_SIZE,
        forced_height = ICON_SIZE,
    }
    -- Icon widget for volume

    -- Text widget to display volume percentage
    local vol_text = wibox.widget {
        widget = wibox.widget.textbox,
        -- screen = s, -- not needed for textbox
    }

    -- Container for the icon and text
    local vol_widget = wibox.widget {
        vol_icon,
        vol_text,
        layout = wibox.layout.fixed.horizontal,
        spacing = 4,
    }

    -- Helper to parse wpctl output
    local function parse_wpctl(stdout)
        if not stdout or stdout == "" then return nil end
        local num = stdout:match("([%d%.]+)")  -- grabs 0.56
        if not num then return nil end
        local muted = stdout:find("MUTED") ~= nil
        local level = math.floor(tonumber(num) * 100 + 0.5)
        return level, muted
    end

    -- Emit signal based on current wpctl state
    local function refresh_volume()
        awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
            local level, muted = parse_wpctl(stdout)
            if level then
                awesome.emit_signal("laptop::volume", level, muted and "M" or "U")
            end
        end)
    end

    -- Update volume widget when volume signal is received
    awesome.connect_signal("laptop::volume", function(level, status)
        local muted = (status == "M")
        vol_text.text = tostring(level) .. "%"
        vol_icon.image = get_volume_icon(tonumber(level), muted)
    end)

    -- Initial visual so it shows up even before first read
    vol_text.text = "--%"
    vol_icon.image = get_volume_icon(0, false)

    -- Initial fetch
    refresh_volume()

    -- Mouse bindings for volume control (and refresh after)
    local function set_and_refresh(cmd)
        awful.spawn.easy_async_with_shell(cmd .. "; wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
            local level, muted = parse_wpctl(stdout)
            if level then
                awesome.emit_signal("laptop::volume", level, muted and "M" or "U")
            else
                -- Fallback, try a separate refresh if parsing failed
                refresh_volume()
            end
        end)
    end

    vol_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            set_and_refresh("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
        end),
        awful.button({}, 4, function()
            set_and_refresh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+")
        end),
        awful.button({}, 5, function()
            set_and_refresh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-")
        end)
    ))

    return vol_widget
end, "right")




-- Battery widget with icon
add_widget("mybattery", function(s)
    local battery_icon = wibox.widget {
        widget = wibox.widget.imagebox,
        resize = true,
    }

    local battery_text = wibox.widget {
        widget = wibox.widget.textbox,
    }

    local battery_widget = wibox.widget {
        battery_icon,
        battery_text,
        layout = wibox.layout.fixed.horizontal,
        spacing = vars.dpi(4),
    }

    awesome.connect_signal("laptop::battery", function(percentage)
        if not percentage then return end
        battery_text.text = percentage .. " "

        local perc_num = tonumber(percentage:match("(%d+)"))
        if perc_num >= 70 then
            battery_icon.image = beautiful.theme_path .. "/icons/battery.png"
        elseif perc_num >= 40 then
            battery_icon.image = beautiful.theme_path .. "/icons/battery_low.png"
        else
            battery_icon.image = beautiful.theme_path .. "/icons/battery_empty.png"
        end
    end)

    return battery_widget
end, "right")

-- System tray
add_widget("mysystray", function(s)
    return wibox.widget {
        widget = wibox.widget.systray,
        screen = s,
    }
end, "right")

-- Return all widgets at the end
return widgets
