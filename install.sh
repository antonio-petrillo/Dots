#!/usr/bin/env bash

dots=("Xresources" "alacritty" "fish" "i3" "kitty" "picom" "tmux" "autostart")
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

if [ -L $HOME/.config/i3status ]; then
    unlink $HOME/.config/i3status
elif [ -d $HOME/.config/i3status ]; then
    rm -rf $HOME/.config/i3status
fi

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

if [[ -n $pkgs ]]; then
    echo "Missing packages: '$pkgs'"
    sudo pacman -S $pkgs
else
    echo "All the packages are already installed"
fi

echo "Compiling get_keyboard.c"
if [[ ! -e $HOME/.config/i3/utils/get_keyboard/get_keyboard.out || ! -x $HOME/.config/i3/utils/get_keyboard/get_keyboard.out ]]; then
    echo "Compiling ..."
    gcc $HOME/.config/i3/utils/get_keyboard/main.c -lX11 -O2 -o $HOME/.config/i3/utils/get_keyboard/get_keyboard.out
else
    echo "Already compiled"
fi
