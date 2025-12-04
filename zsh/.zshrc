# ============================
# ZSH Interactive Configuration
# ============================
setopt autocd cdablevars extendedglob inc_append_history share_history hist_ignore_dups hist_reduce_blanks hist_ignore_space hist_expire_dups_first

HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

# Remove paste highlight
zle_highlight+=(paste:none)

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

# Completions (single call)
autoload -Uz compinit
compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"

# Zinit Plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# FZF
if command -v fzf >/dev/null; then
    export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --color=border:#313244,label:#cdd6f4"
    source <(fzf --zsh)
fi

# Starship
eval "$(starship init zsh)"

# Pyenv init
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Lazy NVM
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  NVM_LAZY_LOAD=true
  source "$NVM_DIR/nvm.sh"
fi

# Zellij (optional)
# eval "$(zellij setup --generate-auto-start zsh)"

# Docker completions
fpath=("$HOME/.docker/completions" $fpath)

# Aliases
alias ls='eza --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lla='eza -la --color=always --group-directories-first --icons'
alias lt='eza --tree --color=always --group-directories-first --icons'
alias brew='env PATH="${PATH//$(pyenv root)/shims:/}" brew'
alias finder='open .'

# Optional
# export OLLAMA_HOST=192.168.50.136