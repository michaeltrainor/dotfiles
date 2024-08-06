# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# zsh colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# zsh history
HISTSIZE=1000000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# zsh completions
autoload -U compinit && compinit
zstyle ':completion:*' menu no

# environment
export PATH="$PATH:~/.local/bin"

# exa
alias ls='exa --color=auto'
alias la='ls -a'
alias ll='ls -lah'

# fzf
export PATH=$PATH:~/.fzf/bin
eval "$(fzf --zsh)"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

# go
export GOBIN="$HOME/go/bin"
export PATH=$PATH:/usr/local/go/bin:$GOBIN

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# neovim
export PATH="$PATH:/opt/nvim-linux64/bin"

# starship
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

# zellij
# eval "$(zellij setup --generate-auto-start zsh)"

