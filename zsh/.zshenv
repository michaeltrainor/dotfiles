# ============================
# Zsh Environment Variables
# ============================
# Loaded for all shells (interactive and non-interactive)

# Source platform detection helpers
if [[ -f "$HOME/.dotfiles/zsh/.zsh-helpers" ]]; then
  source "$HOME/.dotfiles/zsh/.zsh-helpers"
elif [[ -f "${ZDOTDIR:-$HOME}/.zsh-helpers" ]]; then
  source "${ZDOTDIR:-$HOME}/.zsh-helpers"
fi

# ============================
# Locale & Editor
# ============================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER=less
export EDITOR="nvim"

# ============================
# PATH Configuration
# ============================

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Homebrew setup (cross-platform)
if command -v brew >/dev/null 2>&1; then
  # Brew is already in PATH, get its prefix
  BREW_PREFIX="$(brew --prefix)"
  export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
else
  # Brew not in PATH, detect by platform
  if [[ -d "/opt/homebrew" ]]; then
    # Apple Silicon Mac
    BREW_PREFIX="/opt/homebrew"
    export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
  elif [[ -d "/usr/local/Homebrew" ]]; then
    # Intel Mac
    BREW_PREFIX="/usr/local"
    export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
  elif [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    # Linux
    BREW_PREFIX="/home/linuxbrew/.linuxbrew"
    export PATH="$BREW_PREFIX/bin:$BREW_PREFIX/sbin:$PATH"
  fi
fi

# ============================
# Tool Configuration
# ============================

# Bat (cat replacement) - using TokyoNight theme
export BAT_THEME="TwoDark"

# Eza (ls replacement)
unset EZA_COLORS LS_COLORS
export EZA_CONFIG_DIR="$HOME/.config/eza"

# Pyenv (Python version manager)
export PYENV_ROOT="$HOME/.pyenv"

# NVM (Node version manager)
export NVM_DIR="$HOME/.nvm"

# .NET SDK (only if installed via Homebrew)
if [[ -n "$BREW_PREFIX" ]] && [[ -d "$BREW_PREFIX/opt/dotnet/libexec" ]]; then
  export DOTNET_ROOT="$BREW_PREFIX/opt/dotnet/libexec"
  export PATH="$DOTNET_ROOT/tools:$PATH"
fi

# Starship prompt
export STARSHIP_CACHE="$HOME/.starship/cache"

# ============================
# Language Environments
# ============================

# Cargo (Rust)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
