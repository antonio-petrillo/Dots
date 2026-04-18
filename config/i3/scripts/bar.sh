#!/usr/bin/env bash

skip=2
i3status | while :
do
    read line
    if [ $skip -ge 0 ]; then
        ((skip--))
        echo $line
        continue
    fi
    layout="$($HOME/.config/i3/utils/get_keyboard/get_keyboard.out)"
    echo ",[{\"full_text\":\"$layout\",\"name\":\"keyboard\"},${line:2}" || exit 1
done
