if [[ `uname` == 'Darwin' ]]; then
  HOMEBREW_ROOT=`brew --prefix`
  PATH="${HOMEBREW_ROOT}/bin:${PATH}"
fi
