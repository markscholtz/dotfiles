# Installed fzf manually using git which adds the ~/.fzf.zsh file.
# Here the file is sourced if it exists.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# "If you're running fzf in a large git repository, git ls-tree can boost up the speed of the traversal."
# Taken from:
# https://github.com/junegunn/fzf/blob/6b27554cdb4742b3776dc1a7a4b7590c640e7779/README.md#git-ls-tree-for-fast-traversal
export FZF_DEFAULT_COMMAND='
  (git ls-tree -r --name-only HEAD ||
   find . -path "*/\.*" -prune -o -type f -print -o -type l -print |
      sed s/^..//) 2> /dev/null'
