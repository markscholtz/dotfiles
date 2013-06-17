# *****************************************************************************
# Test shell type and perform any customisation based on this below
# Idea taken from: http://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# *****************************************************************************
if [[ -n $PS1 ]]; then
  : # These are executed only for interactive shells
  echo "SHELL: interactive"
else
  : # Only for NON-interactive shells
  echo "SHELL: NON-interactive"
fi

# if shopt -q login_shell ; then # bash specific
if [[ -o login ]]; then # login is zsh specific.
  : # These are executed only when it is a login shell
  echo "SHELL: login"
else
  : # Only when it is NOT a login shell
  echo "SHELL: nonlogin"
fi

