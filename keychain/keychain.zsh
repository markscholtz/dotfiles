# -----------------------------------------------------------------------------
# Use Keychain on linux to save ssh passphrase
# -----------------------------------------------------------------------------
if [[ `uname` == 'Linux' ]]; then
  # TODO: Test that keychain exists: http://stackoverflow.com/questions/592620/check-if-a-program-exists-from-a-bash-script
  keychain id_rsa #2>/dev/null
  source ~/.keychain/`uname -n`-sh
fi

