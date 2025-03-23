# ============================
# ZSH Configuration
# ============================

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

# ============================
# Plugins
# ============================
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# ============================
# FZF (Fuzzy Finder)
# ============================
source <(fzf --zsh)

# ============================
# Starship Prompt
# ============================
export STARSHIP_CACHE=~/.starship/cache
eval "$(starship init zsh)"

# ============================
# Aliases
# ============================
alias ls='eza --git'
alias ll='ls -l -a'
alias la='ls -A'
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

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