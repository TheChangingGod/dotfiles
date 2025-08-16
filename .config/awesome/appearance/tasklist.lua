local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

awesome.set_preferred_icon_size(64)
beautiful.tasklist_disable_task_name = true

local widget_template_tasklist = {
    {
        {
            {
                {
                    id     = 'icon_role',
                    widget = wibox.widget.imagebox,
                },
                margins = 2,
                widget  = wibox.container.margin,
            },
            {
                id     = 'text_role',
                widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.horizontal,
        },
        left  = 5,
        right = 5,
        widget = wibox.container.margin
    },
    id     = 'background_role',
    widget = wibox.container.background,

    -- Store client in widget for later reference
    create_callback = function(self, c, index, objects)
        self._client_ref = c
        if c == client.focus then
            self.bg = beautiful.bg_focus
        else
            self.bg = beautiful.bg_normal
        end
    end,
    update_callback = function(self, c, index, objects)
        self._client_ref = c
        if c == client.focus then
            self.bg = beautiful.bg_focus
        else
            self.bg = beautiful.bg_normal
        end
    end,
}

return function(s)
    assert(s and s.valid, "appearance/tasklist: got nil/invalid screen")

    local tasklist_buttons = {
        awful.button({}, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal("request::activate", "tasklist", {raise = true})
            end
        end),
        awful.button({}, 3, function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),
        awful.button({}, 4, function()
            awful.client.focus.byidx(-1)
        end),
        awful.button({}, 5, function()
            awful.client.focus.byidx(1)
        end),
    }

    local tasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            shape = nil,
        },
        layout   = {
            spacing = 5,
            layout  = wibox.layout.fixed.horizontal,
        },
        widget_template = widget_template_tasklist,
    }

    -- Hook into client focus/unfocus and update only necessary items
    client.connect_signal("focus", function(c)
        for _, item in ipairs(tasklist.children) do
            if item._client_ref then
                if item._client_ref == c then
                    item.bg = beautiful.bg_focus
                else
                    item.bg = beautiful.bg_normal
                end
            end
        end
    end)

    client.connect_signal("unfocus", function(c)
        for _, item in ipairs(tasklist.children) do
            if item._client_ref == c then
                item.bg = beautiful.bg_normal
            end
        end
    end)

    return tasklist
end
