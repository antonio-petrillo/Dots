#!/usr/bin/env bash

if pgrep ffmpeg; then
    pkill ffmpeg
    paplay ~/.config/i3/assets/shutter.wav
    notify-send "Screen Recorded - End"

else
    notify-send "Screen Record - Start"
    paplay ~/.config/i3/assets/shutter.wav
    ffmpeg -f ffmpeg -video_size 2256x1504 -framerate 25 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default "$HOME/Videos/Recordings/$(date).mp4"
fi
