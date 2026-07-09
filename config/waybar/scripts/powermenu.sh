#!/usr/bin/env bash

options=" Shutdown\n Reboot\n Logout\n Lock\n Suspend"
choosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" -theme-str 'window {width: 320px;}')

case "$choosen" in
    *Shutdown)
        hyprshutdown -p "systemctl poweroff"
        ;;
    *Reboot)
        hyprshutdown -p "systemctl reboot"
        ;;
    *Logout)
        hyprshutdown
        ;;
    *Lock)
        hyprlock
        ;;
    *Suspend)
        systemctl suspend
        ;;
esac
