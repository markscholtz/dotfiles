# Prevent ZSH from adding duplicates to $PATH. See
# https://stackoverflow.com/a/13060475 for details.
typeset -aU path

# Prepend
path=("$ZSH/bin" $path)

# Man paths
MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"
