#!/usr/bin/env bash

        is_intl=$(setxkbmap -query | awk '/variant/{print $2}')
echo $is_intl
# i3status | while :
# do
#         read line

#         is_intl=$(setxkbmap -query | awk '/variant/{print $2}')


#         echo "mystuff | $line" || exit 1
# done
