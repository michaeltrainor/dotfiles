#!/usr/bin/env bash
# ============================
# Dotfiles Update Script
# ============================
# Update existing dotfiles installation

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source libraries
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/checks.sh"
source "$SCRIPT_DIR/lib/stow.sh"

# Constants
DOTFILES_DIR=$(get_dotfiles_dir)

# Flags
FORCE=0
ALL_PACKAGES=0
NO_BREW=0
NO_GIT=0
CUSTOM_PACKAGES=()

# Usage
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Update existing dotfiles installation (interactive by default).

Options:
  --force                Non-interactive mode (auto-confirm all prompts)
  --all                  Restow all packages, not just changed ones
  --no-brew              Skip Homebrew updates
  --no-git               Skip git repository update
  --packages PKG1,PKG2   Update only specific packages (comma-separated)
  -h, --help             Show this help message

Examples:
  $(basename "$0")                      # Interactive update
  $(basename "$0") --force              # Non-interactive update
  $(basename "$0") --no-brew            # Skip Homebrew updates
  $(basename "$0") --packages zsh,nvim  # Update specific packages

EOF
  exit 0
}

# Parse arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force)
        FORCE=1
        shift
        ;;
      --all)
        ALL_PACKAGES=1
        shift
        ;;
      --no-brew)
        NO_BREW=1
        shift
        ;;
      --no-git)
        NO_GIT=1
        shift
        ;;
      --packages)
        IFS=',' read -ra CUSTOM_PACKAGES <<< "$2"
        shift 2
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo "Unknown option: $1"
        usage
        ;;
    esac
  done
}

# Print banner
print_banner() {
  cat <<'EOF'

  ╔══════════════════════════════════════════════════════════╗
  ║                                                          ║
  ║               🔄  Dotfiles Update  🔄                   ║
  ║                                                          ║
  ║           Keep your development setup current           ║
  ║                                                          ║
  ╚══════════════════════════════════════════════════════════╝

EOF

  log_info "Dotfiles directory: $DOTFILES_DIR"
  if [[ $FORCE -eq 1 ]]; then
    log_warning "FORCE MODE: All prompts auto-confirmed"
  fi
  echo ""
}

# Verify installation exists
verify_installation() {
  log_header "Verifying Installation"

  # Check if we're in a git repo
  if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    die "Not a git repository: $DOTFILES_DIR"
  fi

  # Quick prerequisite check
  if ! command_exists brew; then
    log_warning "Homebrew not found"
  fi

  if ! command_exists stow; then
    die "GNU Stow not found. Run install.sh first."
  fi

  log_success "Installation verified"
}

# Update git repository
update_repository() {
  if [[ $NO_GIT -eq 1 ]]; then
    log_info "Skipping git update (--no-git)"
    return 0
  fi

  log_header "Updating Repository"

  cd "$DOTFILES_DIR"

  # Check for uncommitted changes
  if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    log_warning "Uncommitted changes detected"

    if [[ $FORCE -eq 1 ]]; then
      log_info "Stashing changes (force mode)"
      git stash push -m "Auto-stash before update $(date +%Y-%m-%d-%H:%M:%S)"
    else
      if prompt_confirm "Stash uncommitted changes?"; then
        git stash push -m "Stash before update $(date +%Y-%m-%d-%H:%M:%S)"
      else
        log_info "Skipping git update"
        return 0
      fi
    fi
  fi

  # Fetch updates
  log_info "Fetching updates..."
  git fetch

  # Check if updates available
  local local_sha=$(git rev-parse HEAD)
  local remote_sha=$(git rev-parse @{u} 2>/dev/null || echo "$local_sha")

  if [[ "$local_sha" == "$remote_sha" ]]; then
    log_success "Already up to date"
    return 0
  fi

  # Show what's new
  echo ""
  log_info "New commits available:"
  git log --oneline --decorate --graph HEAD..@{u} | head -10
  echo ""

  # Prompt to pull
  if [[ $FORCE -eq 1 ]]; then
    log_info "Pulling changes (force mode)"
  else
    if ! prompt_confirm "Pull changes?"; then
      log_info "Skipping git pull"
      return 0
    fi
  fi

  # Pull changes
  if git pull; then
    log_success "Repository updated"
  else
    log_error "Git pull failed"
    return 1
  fi
}

# Update Homebrew packages
update_homebrew() {
  if [[ $NO_BREW -eq 1 ]]; then
    log_info "Skipping Homebrew update (--no-brew)"
    return 0
  fi

  if ! command_exists brew; then
    log_warning "Homebrew not found, skipping"
    return 0
  fi

  log_header "Updating Homebrew Packages"

  cd "$DOTFILES_DIR"

  # Prompt to update
  if [[ $FORCE -eq 1 ]]; then
    log_info "Updating Homebrew packages (force mode)"
  else
    if ! prompt_confirm "Update Homebrew packages?"; then
      log_info "Skipping Homebrew update"
      return 0
    fi
  fi

  # Install new packages from Brewfile
  if brew bundle install; then
    log_success "Homebrew packages updated"
  else
    log_warning "Some packages may have failed"
  fi

  # Prompt for cleanup
  if [[ $FORCE -eq 1 ]]; then
    log_info "Cleaning up unused packages (force mode)"
    brew bundle cleanup --force
  else
    if prompt_confirm "Cleanup unused packages?"; then
      brew bundle cleanup
      log_success "Cleanup complete"
    fi
  fi
}

# Update stow packages
update_stow_packages() {
  log_header "Updating Stow Packages"

  cd "$DOTFILES_DIR"

  # Determine which packages to update
  local packages=()

  if [[ ${#CUSTOM_PACKAGES[@]} -gt 0 ]]; then
    # Custom package list
    packages=("${CUSTOM_PACKAGES[@]}")
    log_info "Updating custom packages: ${packages[*]}"

    # Validate packages
    for pkg in "${packages[@]}"; do
      validate_package "$pkg" "$DOTFILES_DIR" || die "Invalid package: $pkg"
    done
  elif [[ $ALL_PACKAGES -eq 1 ]]; then
    # All packages
    mapfile -t packages < <(get_all_packages "$DOTFILES_DIR")
    log_info "Restowing all packages: ${packages[*]}"
  else
    # Only changed packages
    mapfile -t packages < <(get_changed_packages "$DOTFILES_DIR")

    if [[ ${#packages[@]} -eq 0 ]]; then
      log_success "No package changes detected"
      return 0
    fi

    log_info "Changed packages: ${packages[*]}"
  fi

  # Prompt to restow
  if [[ $FORCE -eq 1 ]]; then
    log_info "Restowing packages (force mode)"
  else
    if ! prompt_confirm "Restow packages?"; then
      log_info "Skipping package update"
      return 0
    fi
  fi

  # Restow packages
  if ! restow_all_packages "$DOTFILES_DIR" "${packages[@]}"; then
    die "Failed to restow packages"
  fi

  log_success "Packages updated"
}

# Update plugin managers
update_plugins() {
  log_header "Updating Plugin Managers"

  # Zinit update (if in zsh)
  if [[ -d "$HOME/.local/share/zinit/zinit.git" ]]; then
    log_info "Zinit will self-update on next zsh launch"
  fi

  # Lazy.nvim update
  log_info "Neovim plugins will update on next :Lazy sync"

  log_success "Plugin managers ready"
}

# Print summary
print_summary() {
  log_header "Update Complete!"

  echo ""
  echo "Summary:"
  echo "  ${SUCCESS} Repository: Updated to latest"

  if [[ $NO_BREW -eq 0 ]]; then
    echo "  ${SUCCESS} Homebrew: Packages updated"
  else
    echo "  ${INFO} Homebrew: Skipped (--no-brew)"
  fi

  if [[ ${#CUSTOM_PACKAGES[@]} -gt 0 ]]; then
    echo "  ${SUCCESS} Stow: ${#CUSTOM_PACKAGES[@]} package(s) updated"
  elif [[ $ALL_PACKAGES -eq 1 ]]; then
    local all_packages
    mapfile -t all_packages < <(get_all_packages "$DOTFILES_DIR")
    echo "  ${SUCCESS} Stow: ${#all_packages[@]} package(s) restowed"
  else
    echo "  ${SUCCESS} Stow: Changed packages restowed"
  fi

  echo ""
  echo "Next Steps:"
  echo "  1. Restart terminal if shell configs changed"
  echo "  2. Open Neovim and run :Lazy sync (if needed)"
  echo ""
}

# Main
main() {
  parse_args "$@"

  # Verify macOS
  require_macos

  # Print banner
  print_banner

  # Verify installation
  verify_installation

  # Update repository
  update_repository

  # Update Homebrew
  update_homebrew

  # Update stow packages
  update_stow_packages

  # Update plugins
  update_plugins

  # Print summary
  print_summary
}

main "$@"
