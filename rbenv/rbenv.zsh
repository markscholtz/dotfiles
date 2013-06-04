if [[ -e "${HOME}/.rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=$HOME/.rbenv
elif [[ -e "/usr/local/rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local/rbenv
fi

export RBENV_ROOT
export PATH="${RBENV_ROOT}/bin:${PATH}"

if [[ -n "${RBENV_ROOT}" ]]; then
  eval "$($RBENV_ROOT/bin/rbenv init -)"
fi

# If you want sources to be kept after builds, also add (useful on OSX for gdb):
export RBENV_BUILD_ROOT=${RBENV_ROOT}/sources

