#!/bin/bash
INSTALLDIR=${INSTALLDIR:-~/.dotfiles}
BRANCH=${BRANCH:-master}
GIT_ARGS=${GIT_ARGS:---depth 1}

# Check for brew
which brew >> /dev/null
if [ "$?" -eq "1" ]; then
  read -p "Homebrew not detected, would you like to set it up? (y/n): " yesno
  if [ $yesno == "y" ] || [ $yesno == "Y" ]; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
    # Make sure git and gpg2 are installed, if so
    brew install git gpg2
  fi
fi

# Check for git
which git >> /dev/null
if [ "$?" -eq "1" ]; then echo "Need Git!"; exit 1; fi

# Check for perl
which perl >> /dev/null
if [ "$?" -eq "1" ]; then echo "Need Perl!"; exit 1; fi

# Check for ~/.dotfiles
if [ -e "$HOME/.dotfiles" ]; then echo ".dotfiles already exists!"; exit 1; fi

# Clone and setup .dotfiles
mkdir -p $INSTALLDIR && pushd $INSTALLDIR >> /dev/null
echo "Cloning $BRANCH to ~/.dotfiles..."
git clone $GIT_ARGS -qb $BRANCH https://github.com/throughnothing/dotfiles .
./install-symlinks && popd >> /dev/null
echo "Done setting up dotfiles symlinks."

read -p "Would you like to install pour Homebrew Packages? (y/n): " yesno
if [ $yesno == "y" ] || [ $yesno == "Y" ]; then
  pushd $INSTALLDIR >> /dev/null
  echo "Installing from Brewfile..."
  brew bundle
  popd >> /dev/null
fi

read -p "Would you like to import your personal gpg key? (y/n): " yesno
if [ $yesno == "y" ] || [ $yesno == "Y" ]; then
  pushd $INSTALLDIR >> /dev/null
  echo "Installing from Brewfile..."
  brew bundle
  popd >> /dev/null
fi