# Zsh environment variables (loaded for all shells)
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:$HOME/.local/bin:$PATH"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER=less
export EDITOR="code --wait"

# Tools
export BAT_THEME="TwoDark"
unset EZA_COLORS LS_COLORS
export EZA_CONFIG_DIR="$HOME/.config/eza"

export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
export PATH="$DOTNET_ROOT/tools:$PATH"

export STARSHIP_CACHE="$HOME/.starship/cache"

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"