#!/usr/bin/env sh

# I should have a variable that tell me I am in zen mode or not
pkill -SIGUSR1 waybar
swaync-client -d # may not be synced correctly
