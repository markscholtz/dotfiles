#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'unbot'); then
cd ~/projects/unboxed/unbot/daemon/unbot
rvm use 1.9.2-p290@unbot
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'unbot' -n 'bash'
tmux set-option -t 'unbot' default-path ~/projects/unboxed/unbot/daemon/unbot


tmux new-window -t 'unbot':2 -n 'daemon'

tmux new-window -t 'unbot':3 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'unbot':1 'rvm use 1.9.2-p290@unbot' C-m


# tab "daemon"

tmux send-keys -t 'unbot':2 'rvm use 1.9.2-p290@unbot' C-m


# tab "git"

tmux send-keys -t 'unbot':3 'rvm use 1.9.2-p290@unbot && tig' C-m



tmux select-window -t 'unbot':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'unbot'
else
    tmux -u switch-client -t 'unbot'
fi