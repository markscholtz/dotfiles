echo "paths ..."

# Prepend
PATH=".:$PATH"
PATH="bin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="$HOME/.sfs:$PATH"
PATH="$ZSH/bin:$PATH"
PATH="/usr/local/heroku/bin:$PATH"
PATH="$HOME/local/bin:$PATH"

# Append
PATH="$PATH:$HOME/bin"
PATH="$PATH:/usr/local/mysql/bin"

# Man paths
MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

