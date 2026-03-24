# General PATH entries that don't belong to a specific topic.
#
# Topic-specific tools manage their own PATH in their respective
# directories (e.g. homebrew/path.zsh, rbenv/path.zsh). All path.zsh
# files are sourced before other shell config — see zsh/zshrc.

# Prevent ZSH from adding duplicates to $PATH. See
# https://stackoverflow.com/a/13060475 for details.
typeset -aU path

path=("$HOME/.local/bin" $path)
path=("$ZSH/bin" $path)

MANPATH="/usr/local/man:$MANPATH"
