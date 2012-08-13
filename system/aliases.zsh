# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."

alias h=history
alias c=clear

# Listing
alias l="ls -alp"
alias lp="ls -p"
alias lm="ls -alp | more"

# Prevent accidental deletion of files
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
