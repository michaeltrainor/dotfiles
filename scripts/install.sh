#!/usr/bin/env bash
# ============================
# Dotfiles Installation Script
# ============================
# One-time bootstrap for macOS systems

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
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%s)"

# Flags
DRY_RUN=0
CUSTOM_PACKAGES=()
CUSTOM_BACKUP_DIR=""
AUTO_BACKUP=0

# Usage
usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Bootstrap dotfiles installation for macOS.

Options:
  --dry-run              Show what would happen without making changes
  --packages PKG1,PKG2   Install only specific packages (comma-separated)
  --backup-dir DIR       Custom backup directory location
  --backup               Automatically backup conflicting files
  -h, --help             Show this help message

Examples:
  $(basename "$0")                          # Full installation
  $(basename "$0") --dry-run                # Preview installation
  $(basename "$0") --packages zsh,nvim      # Install specific packages
  $(basename "$0") --backup                 # Auto-backup conflicts

EOF
  exit 0
}

# Parse arguments
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --packages)
        IFS=',' read -ra CUSTOM_PACKAGES <<< "$2"
        shift 2
        ;;
      --backup-dir)
        CUSTOM_BACKUP_DIR="$2"
        shift 2
        ;;
      --backup)
        AUTO_BACKUP=1
        shift
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

  # Use custom backup dir if provided
  if [[ -n "$CUSTOM_BACKUP_DIR" ]]; then
    BACKUP_DIR="$CUSTOM_BACKUP_DIR"
  fi
}

# Print banner
print_banner() {
  cat <<'EOF'

  ╔══════════════════════════════════════════════════════════╗
  ║                                                          ║
  ║              🚀  Dotfiles Installation  🚀              ║
  ║                                                          ║
  ║          Bootstrap your macOS development setup         ║
  ║                                                          ║
  ╚══════════════════════════════════════════════════════════╝

EOF

  log_info "Dotfiles directory: $DOTFILES_DIR"
  if [[ $DRY_RUN -eq 1 ]]; then
    log_warning "DRY-RUN MODE: No changes will be made"
  fi
  echo ""
}

# Setup backup directory
setup_backup() {
  if [[ $DRY_RUN -eq 1 ]]; then
    log_info "[DRY-RUN] Would create backup directory: $BACKUP_DIR"
    return 0
  fi

  mkdir -p "$BACKUP_DIR"
  log_info "Backup directory: $BACKUP_DIR"
}

# Install Homebrew packages
install_brew_packages() {
  log_header "Installing Homebrew Packages"

  if [[ $DRY_RUN -eq 1 ]]; then
    log_info "[DRY-RUN] Would run: brew bundle install"
    return 0
  fi

  cd "$DOTFILES_DIR"

  if brew bundle install; then
    log_success "Homebrew packages installed"
  else
    log_warning "Some Homebrew packages may have failed (continuing...)"
  fi
}

# Handle stow conflicts
handle_conflicts() {
  local packages=("$@")
  local conflicts_found=0

  log_step "Checking for conflicts..."

  for package in "${packages[@]}"; do
    local conflicts
    if conflicts=$(check_conflicts "$package" "$DOTFILES_DIR"); then
      continue
    else
      conflicts_found=1
      log_warning "Conflicts found for: $package"
      echo "$conflicts" | sed 's/^/  /'
    fi
  done

  if [[ $conflicts_found -eq 0 ]]; then
    log_success "No conflicts detected"
    return 0
  fi

  if [[ $AUTO_BACKUP -eq 1 ]]; then
    log_info "Auto-backup enabled, backing up conflicts..."
    for package in "${packages[@]}"; do
      backup_conflicts "$package" "$DOTFILES_DIR" "$BACKUP_DIR"
    done
    return 0
  fi

  if prompt_confirm "Backup conflicting files and continue?"; then
    for package in "${packages[@]}"; do
      backup_conflicts "$package" "$DOTFILES_DIR" "$BACKUP_DIR"
    done
    return 0
  else
    log_error "Cannot continue with conflicts"
    die "Please resolve conflicts manually or use --backup flag"
  fi
}

# Deploy dotfiles with stow
deploy_dotfiles() {
  log_header "Deploying Dotfiles"

  # Determine which packages to install
  local packages=()
  if [[ ${#CUSTOM_PACKAGES[@]} -gt 0 ]]; then
    packages=("${CUSTOM_PACKAGES[@]}")
    log_info "Installing custom packages: ${packages[*]}"

    # Validate each package
    for pkg in "${packages[@]}"; do
      validate_package "$pkg" "$DOTFILES_DIR" || die "Invalid package: $pkg"
    done
  else
    mapfile -t packages < <(get_all_packages "$DOTFILES_DIR")
    log_info "Installing all packages: ${packages[*]}"
  fi

  # Handle conflicts
  if [[ $DRY_RUN -eq 0 ]]; then
    handle_conflicts "${packages[@]}"
  fi

  # Stow packages
  if ! stow_all_packages "$DOTFILES_DIR" "${packages[@]}"; then
    die "Failed to stow packages"
  fi

  log_success "Dotfiles deployed successfully"
}

# Post-installation setup
post_install() {
  log_header "Post-Installation Setup"

  # Setup git config.local
  local git_template="$DOTFILES_DIR/git/.config/git/config.local.template"
  local git_local="$HOME/.config/git/config.local"

  if [[ ! -f "$git_local" ]]; then
    if [[ $DRY_RUN -eq 1 ]]; then
      log_info "[DRY-RUN] Would create: $git_local"
    else
      mkdir -p "$(dirname "$git_local")"
      cp "$git_template" "$git_local"
      log_success "Created: $git_local"
      log_warning "Edit ~/.config/git/config.local with your name and email"
    fi
  else
    log_info "Git config.local already exists"
  fi
}

# Print completion message
print_completion() {
  local backup_count=$(count_backup_files "$BACKUP_DIR")

  log_header "Installation Complete!"

  echo ""
  echo "Summary:"
  echo "  ${SUCCESS} Prerequisites: Xcode, Homebrew, Stow, Rust, Go"
  echo "  ${SUCCESS} Homebrew: Packages installed from Brewfile"

  if [[ ${#CUSTOM_PACKAGES[@]} -gt 0 ]]; then
    echo "  ${SUCCESS} Stow: ${#CUSTOM_PACKAGES[@]} package(s) deployed"
  else
    local all_packages
    mapfile -t all_packages < <(get_all_packages "$DOTFILES_DIR")
    echo "  ${SUCCESS} Stow: ${#all_packages[@]} package(s) deployed"
  fi

  if [[ $backup_count -gt 0 ]]; then
    echo "  ${INFO} Backups: $backup_count file(s) in $BACKUP_DIR"
  fi

  if [[ ! -f "$HOME/.config/git/config.local" ]] || grep -q "YOUR_NAME" "$HOME/.config/git/config.local" 2>/dev/null; then
    echo "  ${WARNING} Action Required: Edit ~/.config/git/config.local"
  fi

  echo ""
  echo "Next Steps:"
  echo "  1. Restart your terminal (or run: exec zsh)"
  echo "  2. Edit ~/.config/git/config.local with your name and email"
  echo "  3. Open Neovim - lazy.nvim will install plugins automatically"
  echo "  4. Open Zsh - Zinit will install plugins automatically"
  echo ""
  echo "For help: make help"
  echo ""
}

# Main
main() {
  parse_args "$@"

  # Verify macOS
  require_macos

  # Print banner
  print_banner

  # Check and install prerequisites
  if ! check_all_prerequisites; then
    die "Prerequisites not met"
  fi

  # Setup backup
  setup_backup

  # Install Homebrew packages
  install_brew_packages

  # Deploy dotfiles
  deploy_dotfiles

  # Post-installation
  post_install

  # Print completion
  if [[ $DRY_RUN -eq 0 ]]; then
    print_completion
  else
    log_info "[DRY-RUN] Installation preview complete"
  fi
}

main "$@"
