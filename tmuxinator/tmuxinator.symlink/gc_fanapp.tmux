#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'gc-fanapp'); then
cd ~/projects/unboxed/gareth_cliff/iOS/gc-fanapp

env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'gc-fanapp' -n 'bash'
tmux set-option -t 'gc-fanapp' default-path ~/projects/unboxed/gareth_cliff/iOS/gc-fanapp


tmux new-window -t 'gc-fanapp':2 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'gc-fanapp':1 '' C-m


# tab "git"

tmux send-keys -t 'gc-fanapp':2 'tig' C-m



tmux select-window -t 'gc-fanapp':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'gc-fanapp'
else
    tmux -u switch-client -t 'gc-fanapp'
fi