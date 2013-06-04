alias reload!='. ~/.zshrc'

# OS X specifics
if [[ `uname` == 'Darwin' ]]; then
  alias l="ls -alp"

  # Quick way to rebuild the Launch Services database and get rid
  # # of duplicates in the Open With submenu.
  alias fixopenwith='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user'
fi

# Linux specifics
if [[ `uname` == 'Linux' ]]; then
  alias l="ls -alp --color"
  # Access remote home directory
fi

# Ascending directories
alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
# Prevent accidental deletion of files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# Listing
alias lp="ls -p"
alias lm="ls -alp | more"
alias h=history
# XCode
alias xcode="open *.xcodeproj"
# Access home directory
alias rhome="cd /home/$USER"
