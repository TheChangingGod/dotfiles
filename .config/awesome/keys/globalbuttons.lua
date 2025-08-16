local awful = require("awful")
local gears = require("gears")

-- {{{ Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})
-- }}}
