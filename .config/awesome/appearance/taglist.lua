local awful = require("awful")
local vars = require("main.user_variables")
local modkey = vars.modkey

return function(s)
    assert(s and s.valid, "appearance/taglist: got nil/invalid screen")

    local buttons = {
        awful.button({}, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t)
            awful.tag.viewprev(t.screen)
        end),
        awful.button({}, 5, function(t)
            awful.tag.viewnext(t.screen)
        end),
    }

    local widget = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.noempty, -- or .all
        buttons = buttons,
    }

    return widget
end
