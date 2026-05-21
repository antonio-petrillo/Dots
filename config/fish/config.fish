source /usr/share/cachyos-fish-config/cachyos-config.fish

set -g fish_user_paths "$HOME/.local/opt/Odin" $fish_user_paths
alias sinp="setxkbmap -layout us,us -variant ,intl  -option ctrl:nocaps,grp:ctrls_toggle && xinput set-prop 'PIXA3854:00 093A:0274 Touchpad' 'libinput Tapping Enabled' 1"



# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/nto/.opam/opam-init/init.fish' && source '/home/nto/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
