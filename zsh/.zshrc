# fzf
source <(fzf --zsh)

# starship
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

# aliases
alias ls='eza --git'
alias ll='ls -l -a'
alias la='ls -A'

# zed
export EDITOR=zed
