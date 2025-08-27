#!/usr/bin/env bash

cd 
cwd=$(pwd)
entry=$(fzf)
dir=$(dirname $entry)
echo $dir

cd "$HOME/$dir"
tmux
