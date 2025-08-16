-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- keep all external libraries in one directory, clean config folder
local config_dir = awful.util.getdir("config")
package.path = package.path
  .. ";" .. config_dir .. "/libraries/?.lua"
  .. ";" .. config_dir .. "/libraries/?/init.lua"

require("awful.autofocus")

local fishlive =require("fishlive")

-- Theme handling library
local beautiful = require("beautiful")
-- Declarative object management
local ruled = require("ruled")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local vars = require("main.user_variables")
beautiful.init("~/.config/awesome/themes/pywal/theme.lua")
-- }}}


-- error handling
require("main.error")

require("main.layout")
require("main.rule")

require("main.tag")

-- Wibox
require("appearance.taglist")
require("appearance.tasklist")

require("appearance.wibox")

-- Setup Keys
require("keys.clientbuttons")
require("keys.clientkeys")
require("keys.globalbuttons")
require("keys.globalkeys")
require("keys.tagkeys")

-- Nice titlebars
fishlive.plugins.createTitlebarsNiceLib()

-- Bling window swallow
local bling = require("bling")
bling.module.window_swallowing.start()  -- activates window swallowing

require("main.signals")
