alias reloadz='. ~/.zshrc'

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
  alias x=xvfb-run
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
# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(type grc &>/dev/null)
then
  alias netstat="grc netstat"
  alias ping="grc ping"
  alias traceroute="grc traceroute"
fi
if $(type gls &>/dev/null)
then
  # alias ls="gls -F --color"
  # alias l="gls -lAh --color"
  # alias ll="gls -l --color"
  # alias la='gls -A --color'
fi
alias lp="ls -p"
alias lm="ls -alp | more"
alias h=history

# XCode
alias xcode="open *.xcodeproj"

# Access home directory
alias rhome="cd /home/$USER"

# Chef servers
alias -g officelist="knife node list -c ~/.chef/knife.office.rb"
alias -g staginglist="knife node list -c ~/.chef/knife.staging.rb"
alias -g productionlist="knife node list -c ~/.chef/knife.production.rb"

