#!/bin/bash
# This file is meant to be bare-bones, so that it has to be modified as little
# as possible. It should have no deps, and just help get brew installed, and
# dotfiles repository cloned.  From there, scripts inside the dotfiles repository
# will take over.

export INSTALLDIR=${INSTALLDIR:-~/.dotfiles}
BRANCH=${BRANCH:-master}
GIT_ARGS=${GIT_ARGS:---depth 1}

function install_homebrew {
  # Check for brew
  which brew >> /dev/null
  if [ "$?" -eq "1" ]; then
    read -p "Homebrew not detected, would you like to set it up? (y/n): " yesno
    if [ "$yesno" == "y" ] || [ "$yesno" == "Y" ]; then
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
      # Make sure git is installed
      brew install git
    fi
  fi
}

function clone_dotfiles {
  # Check for ~/.dotfiles
  if [ -e "$HOME/.dotfiles" ];
    then echo ".dotfiles already exists!";
  else
    # Clone and setup .dotfiles
    mkdir -p $INSTALLDIR
    pushd $INSTALLDIR >> /dev/null

    echo "Cloning $BRANCH to ~/.dotfiles..."
    git clone $GIT_ARGS -qb $BRANCH https://github.com/throughnothing/dotfiles .
    popd >> /dev/null
    echo "Done cloning dotfiles."
  fi
}

function main {
  # Check for git
  which git >> /dev/null
  if [ "$?" -eq "1" ]; then echo "Need Git!"; exit 1; fi

  install_homebrew
  clone_dotfiles

  pushd $INSTALLDIR >> /dev/null

  echo "Handing off to post-clone.sh script..."
  ./post-clone.sh
  
  popd >> /dev/null
}

main