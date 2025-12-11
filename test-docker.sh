#!/usr/bin/env bash
# ============================
# Docker-based Cross-Platform Testing
# ============================
# Test dotfiles installation in clean environments

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print usage
usage() {
  echo "Usage: $0 [ubuntu|debian|fedora|arch]"
  echo ""
  echo "Test dotfiles installation in different Linux distributions:"
  echo "  ubuntu  - Test on Ubuntu latest"
  echo "  debian  - Test on Debian latest"
  echo "  fedora  - Test on Fedora latest"
  echo "  arch    - Test on Arch Linux latest"
  echo "  all     - Test on all distributions"
  exit 1
}

# Test function
test_distro() {
  local distro=$1
  local image=$2
  
  echo -e "${BLUE}==============================${NC}"
  echo -e "${BLUE}Testing on $distro${NC}"
  echo -e "${BLUE}==============================${NC}"
  
  docker run -it --rm \
    -v "$SCRIPT_DIR:/dotfiles:ro" \
    -w /dotfiles \
    "$image" \
    bash -c "
      set -e
      echo '${YELLOW}Installing dependencies...${NC}'
      
      # Update package manager
      if command -v apt-get >/dev/null; then
        apt-get update -qq
        apt-get install -y -qq git curl build-essential stow zsh > /dev/null
      elif command -v dnf >/dev/null; then
        dnf install -y -q git curl gcc make stow zsh
      elif command -v pacman >/dev/null; then
        pacman -Sy --noconfirm git curl base-devel stow zsh
      fi
      
      echo '${YELLOW}Installing Homebrew...${NC}'
      NONINTERACTIVE=1 bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"
      
      # Add Homebrew to PATH
      eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"
      
      echo '${YELLOW}Testing Homebrew detection...${NC}'
      source /dotfiles/zsh/.zsh-helpers
      if has_brew; then
        echo '${GREEN}✓ Homebrew detected${NC}'
      else
        echo '${RED}✗ Homebrew detection failed${NC}'
        exit 1
      fi
      
      echo '${YELLOW}Testing platform detection...${NC}'
      if is_linux; then
        echo '${GREEN}✓ Linux detected${NC}'
      else
        echo '${RED}✗ Linux detection failed${NC}'
        exit 1
      fi
      
      echo '${YELLOW}Testing zsh configuration...${NC}'
      # Source zshenv
      export HOME=/root
      source /dotfiles/zsh/.zshenv
      
      if [[ \"\$PATH\" == */home/linuxbrew/.linuxbrew/bin* ]]; then
        echo '${GREEN}✓ Homebrew added to PATH${NC}'
      else
        echo '${RED}✗ Homebrew not in PATH${NC}'
        exit 1
      fi
      
      echo '${GREEN}==============================${NC}'
      echo '${GREEN}✓ All tests passed on $distro${NC}'
      echo '${GREEN}==============================${NC}'
    "
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ $distro tests PASSED${NC}"
    return 0
  else
    echo -e "${RED}✗ $distro tests FAILED${NC}"
    return 1
  fi
}

# Main
if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  ubuntu)
    test_distro "Ubuntu" "ubuntu:latest"
    ;;
  debian)
    test_distro "Debian" "debian:latest"
    ;;
  fedora)
    test_distro "Fedora" "fedora:latest"
    ;;
  arch)
    test_distro "Arch Linux" "archlinux:latest"
    ;;
  all)
    echo -e "${BLUE}Testing on all distributions...${NC}"
    failed=0
    
    test_distro "Ubuntu" "ubuntu:latest" || ((failed++))
    test_distro "Debian" "debian:latest" || ((failed++))
    test_distro "Fedora" "fedora:latest" || ((failed++))
    test_distro "Arch Linux" "archlinux:latest" || ((failed++))
    
    echo ""
    echo -e "${BLUE}==============================${NC}"
    if [ $failed -eq 0 ]; then
      echo -e "${GREEN}✓ ALL TESTS PASSED${NC}"
    else
      echo -e "${RED}✗ $failed test(s) FAILED${NC}"
      exit 1
    fi
    echo -e "${BLUE}==============================${NC}"
    ;;
  *)
    echo -e "${RED}Unknown distribution: $1${NC}"
    usage
    ;;
esac
