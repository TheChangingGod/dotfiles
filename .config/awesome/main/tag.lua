local awful = require("awful")
local names = { "d", "α", "β", "γ", "δ", "ε", "ζ", "η", "玖" }
local l = awful.layout.suit
local layouts = { l.tile, l.tile, l.floating, l.fair, l.max, l.max, l.tile.left, l.floating, l.floating }

local M = {}

function M.setup(s)
    awful.tag(names, s, layouts)
end


return M
