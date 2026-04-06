#!/usr/bin/env bash

if pgrep -x "xss-lock" > /dev/null; then
    xset -dpms
    xset s off
    xset s noblank
    killall xss-lock
    notify-send "lock disabled"
else
    xset +dpms
    xset s on
    xset dmps 0 0 600
    xset dpms 0 0 360
    xss-lock --transfer-sleep-lock -- i3lock --nofork
    notify-send "lock enabled"
fi
