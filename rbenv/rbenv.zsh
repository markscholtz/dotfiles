# RBENV_ROOT is exported in ./path.zsh

if [[ -n "${RBENV_ROOT}" ]]; then
  eval "$($RBENV_ROOT/bin/rbenv init -)"

  if [[ ! -L "$RBENV_ROOT/default-gems" ]]; then
    echo "Creating rbenv default-gems file"
    ln -s "$ZSH/rbenv/default-gems" "$RBENV_ROOT"
  fi
fi

# If you want sources to be kept after builds, also add (useful on OSX for gdb):
export RBENV_BUILD_ROOT=${RBENV_ROOT}/sources

