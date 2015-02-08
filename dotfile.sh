# Check for git
which git >> /dev/null
if [ "$?" -eq "1" ]; then echo "Need Git!"; exit 1; fi

# Check for perl
which perl >> /dev/null
if [ "$?" -eq "1" ]; then echo "Need Perl!"; exit 1; fi

# Check for ~/.dotfiles
if [ -e "$HOME/.dotfiles" ]; then echo ".dotfiles already exists!"; exit 1; fi

mkdir ~/.dotfiles && pushd ~/.dotfiles >> /dev/null
if [ -n "$1" ]; then BRANCH=$1; else BRANCH='master'; fi
if [ -n "$2" ]; then GIT_ARGS="--depth 0"; fi
echo "Cloning $BRANCH to ~/.dotfiles..."
git clone $GIT_ARGS -qb $BRANCH https://github.com/throughnothing/dotfiles .
./install && popd >> /dev/null
