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

# ============================
# FZF (Fuzzy Finder)
# ============================
if command -v fzf >/dev/null; then
    # TokyoNight Storm color scheme
    export FZF_DEFAULT_OPTS="--color=bg+:#292e42,bg:#1a1b26,spinner:#7dcfff,hl:#f7768e \
    --color=fg:#c0caf5,header:#7dcfff,info:#bb9af7,pointer:#7dcfff \
    --color=marker:#7dcfff,fg+:#c0caf5,prompt:#bb9af7,hl+:#f7768e \
    --color=selected-bg:#283457 \
    --color=border:#292e42,label:#c0caf5"
    source <(fzf --zsh)
fi

# Starship
eval "$(starship init zsh)"

# Lazy NVM
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  NVM_LAZY_LOAD=true
  source "$NVM_DIR/nvm.sh"
fi

# Docker completions
fpath=("$HOME/.docker/completions" $fpath)

# pyenv
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# ============================
# Aliases
# ============================

# Eza (ls replacement)
alias ls='eza --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lla='eza -la --color=always --group-directories-first --icons'
alias lt='eza --tree --color=always --group-directories-first --icons'

# ============================
# Platform-Specific Aliases
# ============================

if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS-specific aliases
  alias finder='open .'
  alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
  # Linux-specific aliases
  alias finder='xdg-open .'
  alias open='xdg-open'
  # Clipboard aliases (requires xclip)
  if command -v xclip >/dev/null; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
  fi
fi

