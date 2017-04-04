if [[ -e "${HOME}/.rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=$HOME/.rbenv
elif [[ -e "/usr/local/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local
elif [[ -e "/usr/local/rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local/rbenv
fi

export RBENV_ROOT

PATH="${RBENV_ROOT}/bin:${PATH}"
