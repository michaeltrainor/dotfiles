# starship
export STARSHIP_CONFIG=~/.config/starship.toml
eval "$(starship init zsh)"

# exa
alias ls='exa -l --icons'
alias la='exa --time-style=default --git --color-scale --icons --sort=type --group-directories-first -lhaS'
alias ll='exa -lbGFa --git --sort=type --icons --group-directories-first'
alias llm='exa -lbGFa --git --sort=modified'
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons --sort=type --group-directories-first'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# global
export PATH="$PATH:/Users/michaeltrainor/.local/bin"

# zellij
eval "$(zellij setup --generate-auto-start zsh)"
