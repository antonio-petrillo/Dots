hl.on("hyprland.start", function()
         on_system({
               f13  = function() hl.exec_cmd("waybar -c ~/.config/waybar/config-f13.jsonc") end,
               desk = function() hl.exec_cmd("waybar -c ~/.config/waybar/config-desk.jsonc") end,
         })

         hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
         hl.exec_cmd("hypridle")
         hl.exec_cmd("hyprpaper")
         hl.exec_cmd("wl-paste --type text --watch cliphist store")
         hl.exec_cmd("wl-paste --type image --watch cliphist store")
         hl.exec_cmd("nm-applet --indicator")
         hl.exec_cmd("blueman-applet")
         hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)
