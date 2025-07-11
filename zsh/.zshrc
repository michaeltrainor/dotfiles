# ============================
# ZSH Configuration
# ============================
setopt autocd cdablevars extendedglob

# Install Zinit if not already installed
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Load Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
autoload -Uz compinit
compinit

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt inc_append_history share_history hist_ignore_dups hist_reduce_blanks

# ============================
# Plugins
# ============================
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# ============================
# FZF (Fuzzy Finder)
# ============================
if command -v fzf >/dev/null; then
    export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --color=border:#313244,label:#cdd6f4"
    source <(fzf --zsh)
fi

# ============================
# Starship Prompt
# ============================
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

# ============================
# eza
# ============================
unset EZA_COLORS LS_COLORS
export EZA_CONFIG_DIR="$HOME/.config/eza"

# ============================
# Aliases
# ============================
alias ls='eza --git'
alias ll='ls -l -a -X'
alias llx='ls -l -a'
alias la='ls -A'
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias finder='open .'
alias kubectl="minikube kubectl --"

# ============================
# Editor Configuration
# ============================
export EDITOR=nvim

# ============================
# Pyenv (Python Version Manager)
# ============================
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# ============================
# nvm - Node Version Manager
# ============================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
