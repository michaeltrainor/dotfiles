#!/usr/bin/env bash
# ============================
# Prerequisite Checking Functions
# ============================

# Check Xcode Command Line Tools
check_xcode() {
  log_info "Checking Xcode Command Line Tools..."

  if xcode-select -p &>/dev/null && [[ -d "/Library/Developer/CommandLineTools" ]]; then
    log_success "Xcode Command Line Tools installed"
    return 0
  fi

  log_warning "Xcode Command Line Tools not found"
  return 1
}

# Install Xcode Command Line Tools
install_xcode() {
  log_header "Installing Xcode Command Line Tools"

  echo ""
  echo "Please follow these steps:"
  echo "  1. A dialog will open - click 'Install'"
  echo "  2. Wait for the installation to complete (this may take several minutes)"
  echo "  3. Return here and press Enter when done"
  echo ""

  # Trigger the installation dialog
  xcode-select --install 2>/dev/null || true

  wait_for_enter "Press Enter after Xcode installation completes..."

  # Re-check
  if check_xcode; then
    return 0
  else
    log_error "Xcode Command Line Tools still not detected"
    return 1
  fi
}

# Check Homebrew
check_homebrew() {
  log_info "Checking Homebrew..."

  if command_exists brew && brew --version &>/dev/null; then
    log_success "Homebrew installed: $(brew --version | head -n1)"
    return 0
  fi

  log_warning "Homebrew not found"
  return 1
}

# Install Homebrew
install_homebrew() {
  log_header "Installing Homebrew"

  echo ""
  echo "Running official Homebrew installation script:"
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
  echo ""

  if prompt_confirm "Install Homebrew now?"; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -d "/opt/homebrew/bin" ]]; then
      export PATH="/opt/homebrew/bin:$PATH"
    elif [[ -d "/usr/local/bin" ]]; then
      export PATH="/usr/local/bin:$PATH"
    fi

    # Re-check
    if check_homebrew; then
      return 0
    else
      log_error "Homebrew installation failed"
      return 1
    fi
  else
    log_error "Homebrew installation skipped by user"
    return 1
  fi
}

# Check GNU Stow
check_stow() {
  log_info "Checking GNU Stow..."

  if command_exists stow && stow --version &>/dev/null; then
    log_success "GNU Stow installed: $(stow --version | head -n1)"
    return 0
  fi

  log_warning "GNU Stow not found"
  return 1
}

# Install GNU Stow via Homebrew
install_stow() {
  log_header "Installing GNU Stow"

  if ! command_exists brew; then
    log_error "Homebrew is required to install Stow"
    return 1
  fi

  if prompt_confirm "Install GNU Stow via Homebrew?"; then
    brew install stow

    # Re-check
    if check_stow; then
      return 0
    else
      log_error "Stow installation failed"
      return 1
    fi
  else
    log_error "Stow installation skipped by user"
    return 1
  fi
}

# Check Rust
check_rust() {
  log_info "Checking Rust..."

  if command_exists cargo && command_exists rustc && rustc --version &>/dev/null; then
    log_success "Rust installed: $(rustc --version)"
    return 0
  fi

  log_warning "Rust not found"
  return 1
}

# Install Rust via rustup
install_rust() {
  log_header "Installing Rust"

  echo ""
  echo "Please follow these steps to install Rust:"
  echo ""
  echo "  1. Run the following command in a new terminal:"
  echo "     ${BOLD}curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh${RESET}"
  echo ""
  echo "  2. Follow the prompts (default installation is recommended)"
  echo "  3. After installation completes, close that terminal"
  echo "  4. Open a new terminal to load Rust into your PATH"
  echo "  5. Return here and press Enter"
  echo ""

  wait_for_enter "Press Enter after Rust installation completes..."

  # Source cargo env for this session
  if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
  fi

  # Re-check
  if check_rust; then
    return 0
  else
    log_error "Rust still not detected"
    log_info "You may need to restart this script after Rust installation"
    return 1
  fi
}

# Check Go
check_go() {
  log_info "Checking Go..."

  if command_exists go && go version &>/dev/null; then
    log_success "Go installed: $(go version)"
    return 0
  fi

  log_warning "Go not found"
  return 1
}

# Install Go
install_go() {
  log_header "Installing Go"

  echo ""
  echo "Please follow these steps to install Go:"
  echo ""
  echo "  1. Visit: ${BOLD}https://go.dev/dl/${RESET}"
  echo "  2. Download the macOS installer (.pkg file)"
  echo "  3. Run the installer and follow the prompts"
  echo "  4. After installation completes, open a new terminal"
  echo "  5. Return here and press Enter"
  echo ""

  if prompt_confirm "Open Go download page in browser?"; then
    open "https://go.dev/dl/"
  fi

  wait_for_enter "Press Enter after Go installation completes..."

  # Add common Go paths to current session
  export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

  # Re-check
  if check_go; then
    return 0
  else
    log_error "Go still not detected"
    log_info "You may need to restart this script after Go installation"
    return 1
  fi
}

# Check Pyenv
check_pyenv() {
  log_info "Checking Pyenv..."

  if command_exists pyenv && pyenv --version &>/dev/null; then
    local version
    version=$(pyenv --version | awk '{print $2}')
    log_success "Pyenv installed: ${version}"
    return 0
  fi

  log_warning "Pyenv not found"
  return 1
}

# Install Pyenv via git clone
install_pyenv() {
  log_header "Installing Pyenv"
  log_info "Pyenv will be installed via git clone method..."
  echo ""
  log_warning "This installation requires manual steps:"
  echo ""
  echo "  1. Clone pyenv repository:"
  echo "     ${BOLD}git clone https://github.com/pyenv/pyenv.git ~/.pyenv${RESET}"
  echo ""
  echo "  2. Build pyenv (optional but recommended for better performance):"
  echo "     ${BOLD}cd ~/.pyenv && src/configure && make -C src${RESET}"
  echo ""
  echo "  Note: Shell configuration for Pyenv is already in zsh/.zshrc"
  echo ""

  if prompt_confirm "Open installation instructions in browser?"; then
    open "https://github.com/pyenv/pyenv#installation"
  fi

  echo ""
  if prompt_confirm "Have you completed the installation steps above?"; then
    # Source pyenv for current session if it exists
    if [[ -d "$HOME/.pyenv" ]]; then
      export PYENV_ROOT="$HOME/.pyenv"
      export PATH="$PYENV_ROOT/bin:$PATH"
      if command_exists pyenv; then
        eval "$(pyenv init - bash)"
      fi
    fi

    if check_pyenv; then
      return 0
    else
      log_error "Pyenv installation could not be verified"
      log_info "Please ensure pyenv is properly installed and in your PATH"
      return 1
    fi
  else
    log_warning "Skipping Pyenv installation - you can install it later"
    log_info "Installation instructions: https://github.com/pyenv/pyenv#installation"
    return 1
  fi
}

# Check all prerequisites
check_all_prerequisites() {
  log_header "Checking Prerequisites"

  local missing=()

  # Check each prerequisite
  check_xcode || missing+=("xcode")
  check_homebrew || missing+=("homebrew")
  check_stow || missing+=("stow")
  check_rust || missing+=("rust")
  check_go || missing+=("go")
  check_pyenv || missing+=("pyenv")

  # If all present, we're done
  if [[ ${#missing[@]} -eq 0 ]]; then
    log_success "All prerequisites installed!"
    return 0
  fi

  # Report missing
  echo ""
  log_warning "Missing prerequisites: ${missing[*]}"
  echo ""

  if ! prompt_confirm "Install missing prerequisites now?"; then
    log_error "Cannot continue without prerequisites"
    return 1
  fi

  # Install each missing prerequisite
  for prereq in "${missing[@]}"; do
    case "$prereq" in
      xcode)
        install_xcode || return 1
        ;;
      homebrew)
        install_homebrew || return 1
        ;;
      stow)
        install_stow || return 1
        ;;
      rust)
        install_rust || return 1
        ;;
      go)
        install_go || return 1
        ;;
      pyenv)
        install_pyenv || return 1
        ;;
    esac
  done

  # Final verification
  echo ""
  log_header "Verifying Prerequisites"

  local still_missing=()
  check_xcode || still_missing+=("xcode")
  check_homebrew || still_missing+=("homebrew")
  check_stow || still_missing+=("stow")
  check_rust || still_missing+=("rust")
  check_go || still_missing+=("go")
  check_pyenv || still_missing+=("pyenv")

  if [[ ${#still_missing[@]} -gt 0 ]]; then
    log_error "Prerequisites still missing: ${still_missing[*]}"
    return 1
  fi

  log_success "All prerequisites verified!"
  return 0
}
