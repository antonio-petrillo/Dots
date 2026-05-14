source /usr/share/cachyos-fish-config/cachyos-config.fish

set -g fish_user_paths "$HOME/.local/opt/Odin" $fish_user_paths
alias sinp="setxkbmap -layout us,us -variant ,intl  -option ctrl:nocaps,grp:ctrls_toggle && xinput set-prop 'PIXA3854:00 093A:0274 Touchpad' 'libinput Tapping Enabled' 1"

