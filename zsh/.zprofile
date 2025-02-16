# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
