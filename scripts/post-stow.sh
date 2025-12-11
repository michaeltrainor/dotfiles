#!/usr/bin/env bash
# ============================
# Post-Stow Setup Script
# ============================
# Run this after stowing dotfiles to apply platform-specific configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Running post-stow setup...${NC}"

# ============================
# Ghostty Platform-Specific Config
# ============================
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo -e "${YELLOW}Applying macOS-specific Ghostty configuration...${NC}"
  
  GHOSTTY_CONFIG="$HOME/.config/ghostty/config"
  GHOSTTY_MACOS="$HOME/.config/ghostty/config.macos"
  
  if [[ -f "$GHOSTTY_MACOS" ]]; then
    # Check if macOS config already appended
    if ! grep -q "macos-titlebar-style" "$GHOSTTY_CONFIG" 2>/dev/null; then
      echo "" >> "$GHOSTTY_CONFIG"
      cat "$GHOSTTY_MACOS" >> "$GHOSTTY_CONFIG"
      echo -e "${GREEN}✓ Applied macOS Ghostty configuration${NC}"
    else
      echo -e "${YELLOW}⚠ macOS Ghostty config already applied${NC}"
    fi
  fi
fi

# ============================
# TPM Installation
# ============================
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  echo -e "${YELLOW}Installing Tmux Plugin Manager (TPM)...${NC}"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo -e "${GREEN}✓ TPM installed${NC}"
  echo -e "${YELLOW}  Run 'tmux source ~/.tmux.conf' then press prefix + I to install plugins${NC}"
else
  echo -e "${GREEN}✓ TPM already installed${NC}"
fi

# ============================
# Git Local Config
# ============================
GIT_LOCAL="$HOME/.config/git/config.local"
if [[ ! -f "$GIT_LOCAL" ]]; then
  echo -e "${YELLOW}Creating Git local configuration template...${NC}"
  cat > "$GIT_LOCAL" << 'EOF'
# ============================
# Git Local Configuration
# ============================
# This file is not tracked in version control
# Add your personal user data here

[user]
	name = Your Name
	email = your.email@example.com
EOF
  echo -e "${GREEN}✓ Created $GIT_LOCAL${NC}"
  echo -e "${YELLOW}  Please edit this file with your personal information${NC}"
else
  echo -e "${GREEN}✓ Git local config already exists${NC}"
fi

# ============================
# Completion
# ============================
echo -e "${GREEN}Post-stow setup complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Edit ~/.config/git/config.local with your personal information"
echo "  2. Reload your shell: source ~/.zshrc"
echo "  3. For tmux: run 'tmux source ~/.tmux.conf' then press prefix + I"
