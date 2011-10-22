#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'edna'); then
cd ~/projects/unboxed/edna/www/edna
rvm use 1.8.7-p330@edna
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'edna' -n 'bash'
tmux set-option -t 'edna' default-path ~/projects/unboxed/edna/www/edna


tmux new-window -t 'edna':2 -n 'consoles'

tmux new-window -t 'edna':3 -n 'server'

tmux new-window -t 'edna':4 -n 'logs'

tmux new-window -t 'edna':5 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'edna':1 'rvm use 1.8.7-p330@edna' C-m


# tab "consoles"

tmux send-keys -t 'edna':2 'rvm use 1.8.7-p330@edna && script/console' C-m

tmux splitw -t 'edna':2
tmux send-keys -t 'edna':2 'rvm use 1.8.7-p330@edna && script/dbconsole' C-m

tmux select-layout -t 'edna':2 'even-horizontal'


# tab "server"

tmux send-keys -t 'edna':3 'rvm use 1.8.7-p330@edna && script/server' C-m


# tab "logs"

tmux send-keys -t 'edna':4 'rvm use 1.8.7-p330@edna && tail -f log/development.log' C-m


# tab "git"

tmux send-keys -t 'edna':5 'rvm use 1.8.7-p330@edna && tig' C-m



tmux select-window -t 'edna':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'edna'
else
    tmux -u switch-client -t 'edna'
fi