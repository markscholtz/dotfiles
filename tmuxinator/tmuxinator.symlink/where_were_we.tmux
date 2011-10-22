#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'where-were-we'); then
cd ~/projects/wherewerewe/www/wherewerewe
rvm use 1.9.2-p290@wherewerewe
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'where-were-we' -n 'bash'
tmux set-option -t 'where-were-we' default-path ~/projects/wherewerewe/www/wherewerewe


tmux new-window -t 'where-were-we':2 -n 'consoles'

tmux new-window -t 'where-were-we':3 -n 'guard'

tmux new-window -t 'where-were-we':4 -n 'server'

tmux new-window -t 'where-were-we':5 -n 'logs'

tmux new-window -t 'where-were-we':6 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'where-were-we':1 'rvm use 1.9.2-p290@wherewerewe' C-m


# tab "consoles"

tmux send-keys -t 'where-were-we':2 'rvm use 1.9.2-p290@wherewerewe && rails c' C-m

tmux splitw -t 'where-were-we':2
tmux send-keys -t 'where-were-we':2 'rvm use 1.9.2-p290@wherewerewe && rails db' C-m

tmux select-layout -t 'where-were-we':2 'even-horizontal'


# tab "guard"

tmux send-keys -t 'where-were-we':3 'rvm use 1.9.2-p290@wherewerewe && bundle exec guard start' C-m


# tab "server"

tmux send-keys -t 'where-were-we':4 'rvm use 1.9.2-p290@wherewerewe && rails s' C-m


# tab "logs"

tmux send-keys -t 'where-were-we':5 'rvm use 1.9.2-p290@wherewerewe && tail -f log/development.log' C-m

tmux splitw -t 'where-were-we':5
tmux send-keys -t 'where-were-we':5 'rvm use 1.9.2-p290@wherewerewe && tail -f log/test.log' C-m

tmux select-layout -t 'where-were-we':5 'even-vertical'


# tab "git"

tmux send-keys -t 'where-were-we':6 'rvm use 1.9.2-p290@wherewerewe && tig' C-m



tmux select-window -t 'where-were-we':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'where-were-we'
else
    tmux -u switch-client -t 'where-were-we'
fi