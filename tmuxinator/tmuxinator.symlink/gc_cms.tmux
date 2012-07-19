#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'gc-cms'); then
cd ~/projects/unboxed/gareth_cliff/www/gc-cms
rvm use 1.9.2-p136@garethcliff
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'gc-cms' -n 'editor'
tmux set-option -t 'gc-cms' default-path ~/projects/unboxed/gareth_cliff/www/gc-cms


tmux new-window -t 'gc-cms':2 -n 'consoles'

tmux new-window -t 'gc-cms':3 -n 'server'

tmux new-window -t 'gc-cms':4 -n 'logs'

tmux new-window -t 'gc-cms':5 -n 'git'


# set up tabs and panes

# tab "editor"

tmux send-keys -t 'gc-cms':1 'rvm use 1.9.2-p136@garethcliff && vim' C-m

tmux splitw -t 'gc-cms':1
tmux send-keys -t 'gc-cms':1 'rvm use 1.9.2-p136@garethcliff' C-m

tmux select-layout -t 'gc-cms':1 'main-vertical'


# tab "consoles"

tmux send-keys -t 'gc-cms':2 'rvm use 1.9.2-p136@garethcliff && rails c' C-m

tmux splitw -t 'gc-cms':2
tmux send-keys -t 'gc-cms':2 'rvm use 1.9.2-p136@garethcliff && rails db' C-m

tmux select-layout -t 'gc-cms':2 'even-horizontal'


# tab "server"

tmux send-keys -t 'gc-cms':3 'rvm use 1.9.2-p136@garethcliff && rails s' C-m


# tab "logs"

tmux send-keys -t 'gc-cms':4 'rvm use 1.9.2-p136@garethcliff && tail -f log/development.log' C-m


# tab "git"

tmux send-keys -t 'gc-cms':5 'rvm use 1.9.2-p136@garethcliff && tig' C-m



tmux select-window -t 'gc-cms':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'gc-cms'
else
    tmux -u switch-client -t 'gc-cms'
fi