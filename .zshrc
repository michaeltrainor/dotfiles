export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"
plugins=(
	git
	zsh-autosuggestions
	brew
	python
	pip
	pyenv
)

source $ZSH/oh-my-zsh.sh

# dotfiles
export DOTFILES="$HOME/.dev/github/michaeltrainor/dotfiles"
source $DOTFILES/.mtrc
