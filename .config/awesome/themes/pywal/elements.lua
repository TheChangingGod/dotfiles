
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()

-- Icons and paths
theme.icon_path = theme.dir .. "/icons/"
theme.font = "Iosevka Nerd Font 11"
-- theme.awesome_icon = theme.dir .. "/launcher/awesome-icon.png"

-- Colors (fallback if Pywal isn't used)
theme.bg_normal = xrdb.background
theme.bg_focus = xrdb.color12
theme.bg_urgent = xrdb.color9
theme.bg_minimize = xrdb.color8
theme.bg_systray = theme.bg_normal
theme.fg_normal = xrdb.foreground
theme.fg_focus = theme.bg_normal
theme.fg_urgent = theme.bg_normal
theme.fg_minimize = theme.bg_normal

theme.useless_gap = dpi(8)
theme.border_width = dpi(2)
theme.border_normal = xrdb.color0
theme.border_focus = theme.bg_focus
theme.border_marked = xrdb.color10

-- Wibar & menus
theme.wibar_height = dpi(31)
theme.menu_height = dpi(16)
theme.menu_width = dpi(100)
theme.menu_submenu_icon = theme.dir .. "launcher/submenu.png"
theme.tooltip_fg = theme.fg_normal
theme.tooltip_bg = theme.bg_normal

-- Notification icons
theme.clear_icon = theme.icon_path .. "clear.png"
theme.clear_grey_icon = theme.icon_path .. "clear_grey.png"
theme.notification_icon = theme.icon_path .. "notification.png"
theme.delete_icon = theme.icon_path .. "delete.png"
theme.delete_grey_icon = theme.icon_path .. "delete_grey.png"

-- Widgets
theme.widget_ac = theme.icon_path .. "ac.png"
theme.widget_battery = theme.icon_path .. "battery.png"
theme.widget_mem = theme.icon_path .. "mem.png"
theme.widget_cpu = theme.icon_path .. "cpu.png"
theme.widget_temp = theme.icon_path .. "temp.png"
theme.widget_net = theme.icon_path .. "net.png"
theme.widget_hdd = theme.icon_path .. "hdd.png"
theme.widget_music = theme.icon_path .. "note.png"
theme.widget_music_on = theme.icon_path .. "note_on.png"
theme.widget_vol = theme.icon_path .. "vol.png"
theme.widget_vol_low = theme.icon_path .. "vol_low.png"
theme.widget_vol_no = theme.icon_path .. "vol_no.png"
theme.widget_vol_mute = theme.icon_path .. "vol_mute.png"
theme.widget_mail = theme.icon_path .. "mail.png"
theme.widget_mail_on = theme.icon_path .. "mail_on.png"

-- Generate Awesome icon
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Recolor layout and titlebar icons
theme = theme_assets.recolor_layout(theme, theme.fg_normal)
