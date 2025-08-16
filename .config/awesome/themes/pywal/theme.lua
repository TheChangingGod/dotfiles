-- ~/.config/awesome/themes/pywal/theme.lua
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local fishlive = require("fishlive")
local awful = require("awful")
awful.util = require("awful.util")

local json = require("dkjson") -- for Pywal JSON support
local theme_path = awful.util.getdir("config") .. "themes/pywal/"

theme = {}
theme.dir = theme_path

-- Load elements
dofile(theme_path .. "elements.lua")
--dofile(theme_path .. "titlebar.lua")
dofile(theme_path .. "layouts.lua")

-- Set wallpaper and launcher icons
theme.wallpaper       = "~/.local/share/bg"
theme.awesome_icon    = theme_path .. "launcher/awesome-icon.png"
theme.awesome_subicon = theme_path .. "launcher/submenu.png"

-- Function to reload colors from Pywal JSON
function theme.reload_pywal()
    local wal_file = os.getenv("HOME") .. "/.cache/wal/colors.json"
    local f = io.open(wal_file, "r")
    if not f then return end
    local content = f:read("*a")
    f:close()
    local colors, _, err = json.decode(content, 1, nil)
    if err then return end

    local sp = colors.special
    local cs = colors.colors

    theme.bg_normal     = sp.background
    theme.bg_focus      = cs.color4
    theme.bg_urgent     = cs.color1
    theme.bg_minimize   = cs.color8
    theme.fg_normal     = sp.foreground
    theme.fg_focus      = sp.background
    theme.fg_urgent     = sp.background
    theme.fg_minimize   = sp.background
    theme.border_color_normal = cs.color0
    theme.border_color_active = theme.bg_focus
    theme.border_color_marked = cs.color10
end

return theme
