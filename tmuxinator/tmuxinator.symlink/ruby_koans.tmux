#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'ruby-koans'); then
cd ~/dev/ruby/koans
rvm use 1.9.2-p290
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'ruby-koans' -n 'consoles'
tmux set-option -t 'ruby-koans' default-path ~/dev/ruby/koans



# set up tabs and panes

# tab "consoles"

tmux send-keys -t 'ruby-koans':1 'rvm use 1.9.2-p290 && ruby path_to_enlightenment.rb' C-m

tmux splitw -t 'ruby-koans':1
tmux send-keys -t 'ruby-koans':1 'rvm use 1.9.2-p290 && vim' C-m

tmux select-layout -t 'ruby-koans':1 'even-horizontal'



tmux select-window -t 'ruby-koans':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'ruby-koans'
else
    tmux -u switch-client -t 'ruby-koans'
fi