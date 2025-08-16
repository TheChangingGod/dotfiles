
local awful = require("awful")
local wibox = require("wibox")

local appearance = {
    set_wallpaper = require("appearance.wallpaper"),
    mytaglist     = require("appearance.taglist"),
    mytasklist    = require("appearance.tasklist"),
    widgets       = require("appearance.widgets"),
}
local tags = require("main.tag")

-- Automatically create wibar & tags per screen
screen.connect_signal("request::desktop_decoration", function(s)
    appearance.set_wallpaper(s)
    -- 1️⃣ Create tags
    tags.setup(s)

    -- 2️⃣ Promptbox
    s.mypromptbox = awful.widget.prompt()

    -- 3️⃣ Layoutbox
    s.mylayoutbox = awful.widget.layoutbox {
        screen = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }

    -- 4️⃣ Taglist & Tasklist
    s.mytaglist  = appearance.mytaglist(s)
    s.mytasklist = appearance.mytasklist(s)

    -- 5️⃣ Prepare left/right widget containers
    local left_widgets  = { layout = wibox.layout.fixed.horizontal, s.mytaglist, s.mypromptbox }
    local right_widgets = { layout = wibox.layout.fixed.horizontal, s.mylayoutbox }

    for _, entry in ipairs(appearance.widgets.__order) do
        local widget_def = appearance.widgets[entry.name]
        local widget_instance = type(widget_def) == "function" and widget_def(s) or widget_def

        if entry.side == "left" then
            table.insert(left_widgets, 2, widget_instance)
        elseif entry.side == "right" then
            table.insert(right_widgets, 1, widget_instance)
        end
    end

    -- 6️⃣ Create wibar
    s.mywibox = awful.wibar {
        position = "top",
        screen   = s,
        height   = 28,
        widget   = { layout = wibox.layout.align.horizontal, left_widgets, s.mytasklist, right_widgets },
    }
end)
