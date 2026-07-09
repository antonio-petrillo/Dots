#!/usr/bin/env bash

dots=("alacritty" "fish" "kitty" "picom" "tmux" "autostart" "hypr" "waybar" "mako")

for dot in "${dots[@]}"
do
    if [ -L $HOME/.config/$dot ]; then
        echo "LINK: $dot already exists"
        unlink $HOME/.config/$dot
    elif [[ -d $HOME/.config/$dot || -f $HOME/.config/$dot ]]; then
        rm -rf $HOME/.config/$dot
    fi
    ln -s $(pwd)/config/$dot $HOME/.config/$dot
done

directories=("$HOME/Pictures/Screenshots/" "$HOME/Videos/Recordings/")
for directory in "${directories[@]}"
do
    if [ ! -d $directory ]; then
        mkdir -p $directory
    else
        echo "DIR: $directory already exists"
    fi
done

pkgs=$(pacman -Q | awk -f get_package_to_install.awk)

if [[ -n $pkgs ]]; then
    echo "Missing packages: '$pkgs'"
    sudo pacman -S $pkgs
else
    echo "All the packages are already installed"
fi
