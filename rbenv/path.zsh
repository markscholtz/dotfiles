# Detect rbenv installation location and add it to PATH.
if [[ -e "${HOME}/.rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=$HOME/.rbenv
elif [[ -e "/opt/homebrew/bin/rbenv" ]]; then
  RBENV_ROOT=/opt/homebrew
elif [[ -e "/usr/local/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local
elif [[ -e "/usr/local/rbenv/bin/rbenv" ]]; then
  RBENV_ROOT=/usr/local/rbenv
fi

export RBENV_ROOT

path=("${RBENV_ROOT}/bin" $path)
