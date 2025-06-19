#!/usr/bin/env sh

if [ $# -eq 0 ]; then
    echo "usage: change_wallpaper.sh <path to image>"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "$1 is not a file"
    exit 1
fi

pkill swaybg 2>/dev/null
swaybg -i "$1" 2>/dev/null &
echo "wallpaper changed"
