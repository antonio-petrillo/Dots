#!/usr/bin/env bash

dots=("Xresources" "alacritty" "fish" "i3" "kitty" "picom" "tmux" "autostart")
for dot in "${dots[@]}"
do
    if [ -L $HOME/.config/$dot ]; then
        echo "LINK: $dot already exists"
        continue
    elif [[ -d $HOME/.config/$dot || -f $HOME/.config/$dot ]]; then
        rm -rf $HOME/.config/$dot
    fi
    ln -s $(pwd)/config/$dot $HOME/.config/$dot
done

case $(hostname) in
    f13)
        echo "link i3status for laptop framework 13"
        ln -s $(pwd)/config/i3status_f13/ $HOME/.config/i3status
        ;;
    desk)
        echo "link i3status for desktop"
        ln -s $(pwd)/config/i3status_desk/ $HOME/.config/i3status
        ;;
    *)
        echo "Unknown machine $(hostname), can't link i3status dotfile"
        ;;
esac

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

echo "Missing packages: $pkgs"
sudo pacman -S $pkgs
