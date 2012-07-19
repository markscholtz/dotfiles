#!/bin/zsh
tmux start-server

if ! $(tmux has-session -t 'blog'); then
cd ~/projects/blog/www/jekyll_blog
rvm use 1.9.2-p290@jekyll-blog
env TMUX= tmux start-server \; set-option -g base-index 1 \; new-session -d -s 'blog' -n 'bash'
tmux set-option -t 'blog' default-path ~/projects/blog/www/jekyll_blog


tmux new-window -t 'blog':2 -n 'server'

tmux new-window -t 'blog':3 -n 'git'


# set up tabs and panes

# tab "bash"

tmux send-keys -t 'blog':1 'rvm use 1.9.2-p290@jekyll-blog' C-m


# tab "server"

tmux send-keys -t 'blog':2 'rvm use 1.9.2-p290@jekyll-blog && jekyll --server --auto' C-m


# tab "git"

tmux send-keys -t 'blog':3 'rvm use 1.9.2-p290@jekyll-blog && tig' C-m



tmux select-window -t 'blog':1

fi

if [ -z $TMUX ]; then
    tmux -u attach-session -t 'blog'
else
    tmux -u switch-client -t 'blog'
fi