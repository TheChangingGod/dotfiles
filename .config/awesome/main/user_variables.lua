local gears = require("gears")
local beautiful = require("beautiful")

local _M = {
	dpi = beautiful.xresources.apply_dpi,

    browser = "librewolf",
	terminal = "alacritty",
    editor = os.getenv("EDITOR") or "nano",
	modkey = "Mod4",
	altkey = "Mod1",
}

_M.editor_cmd = _M.terminal .. " -e " .. _M.editor

return _M
