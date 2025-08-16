local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup").widget

local vars = require("main.user_variables")
local browser = vars.browser
local terminal = vars.terminal
local modkey = vars.modkey
local altkey = vars.altkey

-- {{{ Key bindings


-- Only cycle through non-empty tags
local function view_nonempty_tag(direction)
    local s = awful.screen.focused()
    local tags = s.tags
    local idx = s.selected_tag.index
    local start = idx

    repeat
        idx = (idx + direction - 1) % #tags + 1
        if #tags[idx]:clients() > 0 then
            tags[idx]:view_only()
            return
        end
    until idx == start
end

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Control"           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey, "Control"          }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
     awful.key({ modkey,            }, "BackSpace",function () awful.spawn("sysact") end,
              {description="run sysact", group="awesome"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),
    awful.key({ modkey }, "d", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),

    awful.key({ modkey }, "b", function()
            awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible
        end,
        { description = "wi(b)ar toggle", group = "awesome" }),


})

-- Custom Programs
awful.keyboard.append_global_keybindings({
    -- Open a web browser (librewolf)
    awful.key({ modkey }, "w", function () awful.spawn(browser) end,
        { description = "open a web browser (librewolf)", group = "launcher" }),

    -- Transformers OCR Binds
    awful.key({ altkey }, "o", function () awful.spawn.with_shell("transformers_ocr recognize") end,
        { description = "Run the manga OCR over selected area", group = "hotkeys" }),
    awful.key({ altkey, "Shift" }, "o", function () awful.spawn.with_shell("transformers_ocr hold") end,
        { description = "Run the manga OCR over multiple areas", group = "hotkeys" }),

    -- Pass
    awful.key({ modkey, "Shift" }, "d", function () awful.spawn("passmenu") end,
        { description = "Load pass", group = "launcher" }),

    -- Abook
    awful.key({ modkey, "Shift" }, "e", function ()
        awful.spawn.with_shell(terminal .. " -e abook -C ~/.config/abook/abookrc --datafile ~/.config/abook/addressbook")
    end, { description = "Open addressbook (abook)", group = "launcher" }),

    -- Btop
    awful.key({ modkey, "Shift" }, "r", function ()
        awful.spawn.with_shell(terminal .. " -e btop")
    end, { description = "Open system monitor (Btop)", group = "launcher" }),

    -- Cabl
    awful.key({ altkey }, "c", function () awful.spawn.with_shell("cabl") end,
        { description = "Plumb selected text with cabl", group = "launcher" }),
    awful.key({ altkey, "Shift" }, "c", function () awful.spawn.with_shell("cabl clip") end,
        { description = "Plumb text from clipboard", group = "launcher" }),

    -- Newsboat & Ncmpcpp
    awful.key({ altkey }, "n", function ()
        awful.spawn.with_shell(terminal .. " -e newsboat")
    end, { description = "Open RSS feeds (newsboat)", group = "launcher" }),
    awful.key({ altkey, "Shift" }, "n", function ()
        awful.spawn(terminal .. " -e ncmpcpp")
    end, { description = "Launch Music player (ncmpcpp)", group = "launcher" }),

    -- Vimwiki
    awful.key({ modkey, "Shift" }, "w", function ()
        awful.spawn(terminal .. " -e nvim -c VimwikiIndex")
    end, { description = "Open Vimwiki", group = "launcher" }),
})

-- {{{ System Bindings
awful.keyboard.append_global_keybindings({
    -- Audio and Screen Brightness Bindings
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("xbacklight -inc 15")
    end, { description = "Increase Brightness by 15%", group = "system" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("xbacklight -dec 15")
    end, { description = "Decrease Brightness by 15%", group = "system" }),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn.with_shell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; kill -44 $(pidof dwmblocks)")
    end, { description = "Mute Audio", group = "system" }),
    awful.key({}, "XF86AudioMicMute", function()
        os.execute("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
    end, { description = "Mute Microphone Audio", group = "system" }),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+; kill -44 $(pidof dwmblocks)")
    end, { description = "Raise volume +3%", group = "system" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.with_shell("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-; kill -44 $(pidof dwmblocks)")
    end, { description = "Lower volume -3%", group = "system" }),

    -- MPD Binds
    awful.key({ modkey }, "p", function() awful.spawn("mpc toggle") end,
              { description = "Pause MPD", group = "hotkeys" }),
    awful.key({ modkey }, ".", function() awful.spawn("mpc next") end,
              { description = "Go to Next track", group = "hotkeys" }),
    awful.key({ modkey, "Shift" }, ".", function() awful.spawn("mpc repeat") end,
              { description = "Toggle Repeat Mode", group = "hotkeys" }),
    awful.key({ modkey }, ",", function() awful.spawn("mpc prev") end,
              { description = "Go to previous track", group = "hotkeys" }),
    awful.key({ modkey, "Shift" }, ",", function() awful.spawn("mpc seek 0%") end,
              { description = "Go to start of track", group = "hotkeys" }),

    -- XF86 Music keys
    awful.key({}, "XF86AudioPrev", function() awful.spawn("mpc prev") end,
              { description = "Previous track", group = "music" }),
    awful.key({}, "XF86AudioNext", function() awful.spawn("mpc next") end,
              { description = "Next track", group = "music" }),
    awful.key({}, "XF86AudioPause", function() awful.spawn("mpc pause") end,
              { description = "Pause track", group = "music" }),
    awful.key({}, "XF86AudioPlay", function() awful.spawn("mpc play") end,
              { description = "Play track", group = "music" }),
    awful.key({}, "XF86AudioStop", function() awful.spawn("mpc stop") end,
              { description = "Stop track", group = "music" }),
    awful.key({}, "XF86AudioRewind", function() awful.spawn("mpc seek -10") end,
              { description = "Seek -10s", group = "music" }),
    awful.key({}, "XF86AudioForward", function() awful.spawn("mpc seek +10") end,
              { description = "Seek +10s", group = "music" }),

    -- Screenshots & recording
    awful.key({}, "Print", function() awful.spawn("maimpick full") end,
              { description = "Take a screenshot", group = "hotkeys" }),
    awful.key({ "Shift" }, "Print", function() awful.spawn("maimpick") end,
              { description = "Open maimpick menu", group = "hotkeys" }),
    awful.key({ modkey }, "Print", function() awful.spawn("dmenurecord") end,
              { description = "Open recording menu", group = "hotkeys" }),
    awful.key({ modkey, "Shift" }, "Print", function() awful.spawn("dmenurecord kill") end,
              { description = "Kill recording", group = "hotkeys" }),
    awful.key({ modkey }, "Scroll_Lock", function()
        awful.spawn.with_shell("killall screenkey || screenkey &")
    end, { description = "Show key presses", group = "launcher" }),
    awful.key({ modkey, "Control" }, "c", function()
        awful.spawn.with_shell(
            "mpv --no-cache --no-osc --no-input-default-bindings " ..
            "--input-conf=/dev/null --title=mpvfloat $(ls /dev/video[0,2,4,6,8] | tail -n 1)"
        )
    end, { description = "Open webcam for screencasting", group = "launcher" }),
})


 -- }}}

 -- Function Keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey }, "F2", function ()
        awful.spawn.with_shell(terminal .. " -e lfcd")
    end, { description = "Launch File browser (lf)", group = "launcher" }),

    awful.key({ modkey }, "F3", function ()
        awful.spawn(browser)
    end, { description = "Open a web browser (librewolf)", group = "launcher" }),

    awful.key({ modkey }, "F4", function ()
        awful.spawn.with_shell(terminal .. " -e pulsemixer")
    end, { description = "Open Volume Control", group = "launcher" }),

    awful.key({ modkey }, "F8", function ()
        awful.spawn("qbittorrent")
    end, { description = "Launch Torrent Client (qBittorrent)", group = "launcher" }),

    awful.key({ modkey }, "F10", function ()
        awful.util.spawn("anki")
    end, { description = "Launch Anki (SRS)", group = "hotkeys" }),

    awful.key({ modkey }, "F11", function ()
        awful.spawn.with_shell("mpv --untimed --no-cache --no-osc --no-input-default-bindings --profile=low-latency --input-conf=/dev/null --title=webcam $(ls /dev/video[0,2,4,6,8] | tail -n 1)")
    end, { description = "Toggle Webcam", group = "launcher" }),
})


-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "g", function() view_nonempty_tag(-1) end,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, }, ";", function() view_nonempty_tag(1) end,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:activate { raise = true, context = "key.unminimize" }
                  end
              end,
              {description = "restore minimized", group = "client"}),
})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),
})




client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)



-- }}}
