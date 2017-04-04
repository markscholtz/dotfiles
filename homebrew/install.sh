#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct Homebrew for each OS type.
  if test "$(uname)" = "Darwin"
  then
    # Don't install Homebrew using this script due to work specific reasons.
    # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "  Skipping Homebrew installation."
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    # Don't install Homebrew on any *nix OSes for now.
    # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
    echo "  Skipping Homebrew installation."
  fi

fi

exit 0
