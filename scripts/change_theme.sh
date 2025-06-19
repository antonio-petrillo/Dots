#!/usr/bin/env bash

# See https://github.com/YaLTeR/dotfiles/blob/master/private_dot_local/bin/executable_set-theme

if [ "$(dconf read /org/gnome/desktop/interface/color-scheme)" = "'prefer-dark'" ]; then
  CURRENT_STYLE="dark"
else
  CURRENT_STYLE="light"
fi

if [ "$1" = "dark" ]; then
  STYLE="dark"
elif [ "$1" = "light" ]; then
  STYLE="light"
elif [ "$CURRENT_STYLE" = "dark" ]; then
  STYLE="light"
else
  STYLE="dark"
fi

if [ "$STYLE" = "$CURRENT_STYLE" ]; then
  exit 0
fi

if [ "$STYLE" = "dark" ]; then
  GHOSTTY_INVERSE="LightOwl"
  GHOSTTY_STYLE="DoomOne"
  INVERSE="light"
  COLOR_SCHEME="prefer-dark"
elif [ "$STYLE" = "light" ]; then
  GHOSTTY_INVERSE="DoomOne"
  GHOSTTY_STYLE="LightOwl"
  INVERSE="dark"
  COLOR_SCHEME="prefer-light"
fi

# start transition
niri msg action do-screen-transition -d 1400

# set bar
sed -i "1 s/$INVERSE/$STYLE/g" ~/.config/waybar/style.css
pkill -SIGUSR2 waybar

# set notification center
sed -i "1 s/$INVERSE/$STYLE/g" ~/.config/swaync/style.css
swaync-client -rs

# set gnome theme
dconf write /org/gnome/desktop/interface/color-scheme "\"$COLOR_SCHEME\""

# set launcher
sed -i "s/$INVERSE/$STYLE/g" ~/.config/fuzzel/fuzzel.ini

# set terminal
sed -i "s/$GHOSTTY_INVERSE/$GHOSTTY_STYLE/g" ~/.config/ghostty/config
