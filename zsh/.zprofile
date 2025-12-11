# ============================
# Login Shell Configuration
# ============================
# Loaded once per login session

# ============================
# Homebrew Shell Environment (cross-platform)
# ============================
if command -v brew >/dev/null 2>&1; then
  # Brew already in PATH, initialize shell environment
  eval "$(brew shellenv)"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
  # Apple Silicon Mac
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  # Intel Mac
  eval "$(/usr/local/bin/brew shellenv)"
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  # Linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ============================
# Third-Party Tools
# ============================

# Swiftly (Swift version manager) - cross-platform
[[ -f "$HOME/.swiftly/env.sh" ]] && source "$HOME/.swiftly/env.sh"