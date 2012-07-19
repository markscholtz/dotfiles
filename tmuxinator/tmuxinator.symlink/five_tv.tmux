#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'five-tv'); then
cd ~/projects/unboxed/five_tv/www/five-tv
rvm use 1.8.7-p330@five-tv
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'five-tv' -n 'bash'
tmux set-option -t 'five-tv' default-path ~/projects/unboxed/five_tv/www/five-tv


tmux new-window -t 'five-tv':2 -n 'consoles'

tmux new-window -t 'five-tv':3 -n 'server'

tmux new-window -t 'five-tv':4 -n 'logs'

tmux new-window -t 'five-tv':5 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'five-tv':1 'rvm use 1.8.7-p330@five-tv' C-m


# tab "consoles"

tmux send-keys -t 'five-tv':2 'rvm use 1.8.7-p330@five-tv && script/console' C-m

tmux splitw -t 'five-tv':2
tmux send-keys -t 'five-tv':2 'rvm use 1.8.7-p330@five-tv && script/dbconsole' C-m

tmux select-layout -t 'five-tv':2 'even-horizontal'


# tab "server"

tmux send-keys -t 'five-tv':3 'rvm use 1.8.7-p330@five-tv && script/server' C-m


# tab "logs"

tmux send-keys -t 'five-tv':4 'rvm use 1.8.7-p330@five-tv && tail -f log/development.log' C-m

tmux splitw -t 'five-tv':4
tmux send-keys -t 'five-tv':4 'rvm use 1.8.7-p330@five-tv && tail -f log/test.log' C-m

tmux select-layout -t 'five-tv':4 'even-vertical'


# tab "git"

tmux send-keys -t 'five-tv':5 'rvm use 1.8.7-p330@five-tv && tig' C-m



tmux select-window -t 'five-tv':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'five-tv'
else
    tmux -u switch-client -t 'five-tv'
fi