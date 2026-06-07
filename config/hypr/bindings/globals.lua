local SUPER = "SUPER"

local apps = require("apps")
-- local settings = require("settings")

hl.bind(SUPER .. " + RETURN", hl.dsp.exec_cmd(apps.terminal))
local closeWindowBind = hl.bind(SUPER .. " + SHIFT + Q", hl.dsp.window.close())

-- closeWindowBind:set_enabled(false)
hl.bind(SUPER .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(SUPER .. " + F", hl.dsp.window.fullscreen())
hl.bind(SUPER .. " + SHIFT + C", hl.dsp.window.center())
hl.bind(SUPER .. " + SHIFT + P", hl.dsp.window.pin())
hl.bind(SUPER .. " + U", hl.dsp.focus({ urgent_or_last = true }))

hl.bind(SUPER .. " + C", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
hl.bind(SUPER .. " + D", hl.dsp.exec_cmd(apps.menu))
hl.bind(SUPER .. " + SHIFT + D", hl.dsp.exec_cmd(apps.menu_2))

hl.define_submap("resize", function()
                    hl.bind("H", hl.dsp.window.resize({ x = 10, y = 0, relative = true}), { repeating = true })
                    hl.bind("J", hl.dsp.window.resize({ x = 0, y = -10, relative = true}), { repeating = true })
                    hl.bind("K", hl.dsp.window.resize({ x = 0, y = 10, relative = true}), { repeating = true })
                    hl.bind("L", hl.dsp.window.resize({ x = -10, y = 0, relative = true}), { repeating = true })

                    hl.bind("catchall", hl.dsp.submap("reset"))
end)

hl.bind(SUPER .. " + R", hl.dsp.submap("resize"))

-- Switch workspaces with SUPER + [0-9]
-- Move active window to a workspace with SUPER + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(SUPER .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(SUPER .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with SUPER + scroll
hl.bind(SUPER .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(SUPER .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with SUPER + LMB/RMB and dragging
hl.bind(SUPER .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(SUPER .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" \"$(xdg-user-dir PICTURES)\"/Screenshots/$(date +%d-%m-%Y_T_%H:%H:%S).png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind(SUPER .. "+ Print", hl.dsp.exec_cmd("grim \"$(xdg-user-dir PICTURES)\"/Screenshots/$(date +%d-%m-%Y_T_%H:%H:%S).png"))
hl.bind(SUPER .. " + SHIFT + Print", hl.dsp.exec_cmd("grim - | wl-copy"))
