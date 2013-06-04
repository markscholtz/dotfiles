if [[ `uname` == 'Darwin' ]]; then
  HOMEBREW_ROOT=`brew --prefix`
  export PATH="${HOMEBREW_ROOT}/bin:${PATH}"
fi
