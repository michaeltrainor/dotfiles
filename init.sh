SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# variables
export DOTFILES=$SCRIPTPATH/src

# links
ln -sfn $DOTFILES/.config/alacritty ~/.config/alacritty
ln -sfn $DOTFILES/.config/nvim ~/.config/nvim

# sourcing
source $DOTFILES/.mtalias
source $DOTFILES/.mtenv
source $DOTFILES/.mtfunc

# patch .zprofile
append_files $DOTFILES/.mtprofile $HOME/.zprofile > /dev/null
