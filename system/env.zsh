if [[ `uname` == 'Darwin' ]]; then
  # Make sure that the correct readline is used when installing new packages (OS X)
  export LDFLAGS=-L/usr/local/Cellar/readline/6.2.1/lib
  export CPPFLAGS=-I/usr/local/Cellar/readline/6.2.1/include
fi

if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export EDITOR='vim'

export DISPLAY=:16.0

# Add colours to ls output (OS X)
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

# Add colours to ls output (Linux)
default="00"
bold="01"
underlined="04"
flashing="05"
reversetd="07"
reversetd="08"
red="31"
green="32"
orange="33"
blue="34"
purple="35"
cyan="36"
grey="37"
black_background="40"
red_background="41"
green_background="42"
orange_background="43"
blue_background="44"
purple_background="45"
cyan_background="46"
grey_background="47"
grey_background="48"
export LS_COLORS=":cd=${blue};${orange_background}:" # Character (unbuffered) special file
LS_COLORS+="di=${blue}:"                              # Directory
LS_COLORS+=":ow=${default};${orange_background}:"     # Directory that is other-writable (o+w) and not sticky
LS_COLORS+=":sg=${default};${cyan_background}:"       # File that is setgid (g+s)
LS_COLORS+=":su=${default};${red_background}:"        # File that is setuid (u+s)
LS_COLORS+=":tw=${default};${green_background}:"      # Directory that is sticky and other-writable (+t,o+w)
LS_COLORS+="bd=${blue};${cyan_background}:"           # Block (buffered) special file
LS_COLORS+="ex=${red}:"                               # File which is executable
LS_COLORS+="ln=${purple}:"                            # Symbolic links
LS_COLORS+="mi=${bold};${purple}:"                    # Non-existent file pointed to by a symbolic link
LS_COLORS+="or=${green}:"                             # Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="pi=${orange};${black_background}:"        # Fifo file
LS_COLORS+="so=${green};${black_background}:"         # Socket file

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=7000 # Different from HISTSIZE due to ZSH HIST_EXPIRE_DUPS_FIRST option.

[ -s $HOME/.nvm/nvm.sh ] && . $HOME/.nvm/nvm.sh # This loads NVM

