if [[ -e "${HOME}/.rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=$HOME/.rbenv
elif [[ -e "/usr/local/rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local/rbenv
fi

export RBENV_ROOT
PATH="${RBENV_ROOT}/bin:${PATH}"

if [[ -n "${RBENV_ROOT}" ]]; then
  eval "$($RBENV_ROOT/bin/rbenv init -)"

  if [[ ! -L "$RBENV_ROOT/default-gems" ]]; then
    echo "Creating rbenv default-gems file"
    ln -s "$ZSH/rbenv/default-gems" "$RBENV_ROOT"
  fi
fi

# If you want sources to be kept after builds, also add (useful on OSX for gdb):
export RBENV_BUILD_ROOT=${RBENV_ROOT}/sources

