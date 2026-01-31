# Installation Scripts

Automated installation and update scripts for the dotfiles repository.

## Quick Start

```bash
# Full installation (first time setup)
make install

# Update existing installation
make update

# Preview installation
make dry-run

# Show all available commands
make help
```

## Scripts Overview

### install.sh - Bootstrap Installation

One-time setup script for new macOS systems.

**What it does:**
1. Checks and installs prerequisites (Xcode, Homebrew, Rust, Go, Pyenv, Stow)
2. Backs up conflicting dotfiles
3. Installs Homebrew packages from Brewfile
4. Deploys dotfiles using GNU Stow
5. Sets up git config.local from template

**Usage:**
```bash
# Full installation
./scripts/install.sh

# Preview without changes
./scripts/install.sh --dry-run

# Install specific packages only
./scripts/install.sh --packages zsh,nvim,git

# Auto-backup conflicts
./scripts/install.sh --backup

# Custom backup location
./scripts/install.sh --backup-dir ~/.my-backup
```

**Options:**
- `--dry-run` - Show what would happen without making changes
- `--packages PKG1,PKG2` - Install only specific packages (comma-separated)
- `--backup-dir DIR` - Custom backup directory location
- `--backup` - Automatically backup conflicting files without prompting
- `-h, --help` - Show help message

### update.sh - Update Existing Installation

Interactive update script for keeping your dotfiles current.

**What it does:**
1. Verifies existing installation
2. Updates git repository (pulls latest changes)
3. Updates Homebrew packages
4. Restows changed packages
5. Updates plugin managers (Zinit, lazy.nvim)

**Usage:**
```bash
# Interactive update (prompts for confirmation)
./scripts/update.sh

# Non-interactive update (auto-confirm all)
./scripts/update.sh --force

# Update specific packages only
./scripts/update.sh --packages zsh,nvim

# Restow all packages (not just changed)
./scripts/update.sh --all

# Skip Homebrew updates
./scripts/update.sh --no-brew

# Skip git pull
./scripts/update.sh --no-git
```

**Options:**
- `--force` - Non-interactive mode (auto-confirm all prompts)
- `--all` - Restow all packages, not just changed ones
- `--no-brew` - Skip Homebrew updates
- `--no-git` - Skip git repository update
- `--packages PKG1,PKG2` - Update only specific packages
- `-h, --help` - Show help message

## Library Files

The `lib/` directory contains modular, reusable functions:

### lib/colors.sh
Color output utilities and symbols for user-friendly terminal output.

**Functions:**
- `log_success()` - Print success message with ✓
- `log_error()` - Print error message with ✗
- `log_info()` - Print info message with →
- `log_warning()` - Print warning message with !
- `log_prompt()` - Print prompt message with ?
- `log_header()` - Print section header
- `log_step()` - Print step message
- `show_spinner()` - Show spinner for long operations

### lib/utils.sh
Common utility functions.

**Functions:**
- `get_dotfiles_dir()` - Get dotfiles directory path
- `prompt_confirm()` - Prompt for yes/no confirmation
- `wait_for_enter()` - Wait for user to press Enter
- `command_exists()` - Check if command is available
- `backup_item()` - Backup a file or directory
- `count_backup_files()` - Count files in backup directory
- `die()` - Exit with error message
- `is_macos()` - Check if running on macOS
- `require_macos()` - Verify macOS or exit
- `get_all_packages()` - Get list of all stow packages
- `parse_package_list()` - Parse comma-separated packages
- `validate_package()` - Validate package exists

### lib/checks.sh
Prerequisite checking and installation functions.

**Functions:**
- `check_xcode()` - Check Xcode Command Line Tools
- `install_xcode()` - Install Xcode CLI Tools (waits for user)
- `check_homebrew()` - Check Homebrew installation
- `install_homebrew()` - Install Homebrew
- `check_stow()` - Check GNU Stow installation
- `install_stow()` - Install Stow via Homebrew
- `check_rust()` - Check Rust installation
- `install_rust()` - Guide Rust installation via rustup (waits for user)
- `check_go()` - Check Go installation
- `install_go()` - Guide Go installation (waits for user)
- `check_pyenv()` - Check Pyenv installation
- `install_pyenv()` - Guide Pyenv installation via git clone (waits for user)
- `check_all_prerequisites()` - Check and install all prerequisites

### lib/stow.sh
GNU Stow operation functions.

**Functions:**
- `stow_package()` - Stow a single package
- `restow_package()` - Restow a package (refresh symlinks)
- `unstow_package()` - Unstow a package (remove symlinks)
- `stow_all_packages()` - Stow multiple packages
- `restow_all_packages()` - Restow multiple packages
- `get_changed_packages()` - Get packages changed in git
- `verify_package()` - Verify package is properly stowed
- `check_conflicts()` - Check for stow conflicts
- `backup_conflicts()` - Backup conflicting files

## Prerequisites

The installation script checks and helps install:

1. **Xcode Command Line Tools** (manual)
   - Check: `xcode-select -p`
   - Install: `xcode-select --install`
   - Script will wait for you to complete installation

2. **Homebrew** (auto-installable)
   - Check: `brew --version`
   - Install: Official Homebrew script
   - Script can install automatically

3. **GNU Stow** (auto-installable)
   - Check: `stow --version`
   - Install: `brew install stow`
   - Script can install automatically

4. **Rust** (manual via rustup)
   - Check: `rustc --version && cargo --version`
   - Install: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
   - Script will guide you through installation

5. **Go** (manual)
   - Check: `go version`
   - Install: Download from https://go.dev/dl/
   - Script will guide you through installation

6. **Pyenv** (manual via git clone)
   - Check: `pyenv --version`
   - Install: `git clone https://github.com/pyenv/pyenv.git ~/.pyenv`
   - Script will guide you through installation

## Common Use Cases

### First Time Setup
```bash
# Clone dotfiles
git clone <your-repo> ~/.dotfiles
cd ~/.dotfiles

# Run installation
make install

# Follow prompts to install prerequisites
# Restart terminal when complete
exec zsh
```

### Regular Updates
```bash
cd ~/.dotfiles
make update

# Script will:
# - Pull latest changes from git
# - Update Homebrew packages
# - Restow changed packages
# - Update plugin managers
```

### Selective Package Installation
```bash
# Install only shell and editor configs
./scripts/install.sh --packages zsh,nvim,git

# Update only specific packages
./scripts/update.sh --packages zsh,nvim
```

### Testing Changes
```bash
# Preview what installation would do
make dry-run

# Or with the script directly
./scripts/install.sh --dry-run
```

## Troubleshooting

### Stow Conflicts

If you get conflicts when stowing:

```bash
# Option 1: Use auto-backup
./scripts/install.sh --backup

# Option 2: Manual backup
mv ~/.zshrc ~/.zshrc.backup
./scripts/install.sh

# Option 3: Install specific packages only
./scripts/install.sh --packages nvim,git
```

### Prerequisites Not Detected

If prerequisites aren't detected after installation:

```bash
# Restart your terminal
exec zsh

# Or source the environment
source ~/.zshenv

# Then re-run the script
./scripts/install.sh
```

### Git Config Not Working

If git commands fail:

```bash
# Edit your local config
vim ~/.config/git/config.local

# Add your details:
# [user]
#   name = Your Name
#   email = your.email@example.com
```

### Rollback Installation

To undo dotfiles installation:

```bash
# Unstow all packages
make unstow

# Restore backups (if created)
cp -r ~/.dotfiles-backup-<timestamp>/* ~/

# Uninstall Homebrew packages
brew bundle cleanup --force
```

## Recovery

All backups are timestamped and stored in `~/.dotfiles-backup-<timestamp>`.

To restore a backup:

```bash
# List available backups
ls -la ~/.dotfiles-backup-*

# Restore from specific backup
cp -r ~/.dotfiles-backup-1705339200/* ~/
```

## Development

### Adding New Checks

To add a new prerequisite check, edit `lib/checks.sh`:

```bash
# Add check function
check_newtool() {
  log_info "Checking New Tool..."
  if command_exists newtool; then
    log_success "New Tool installed"
    return 0
  fi
  log_warning "New Tool not found"
  return 1
}

# Add install function
install_newtool() {
  log_header "Installing New Tool"
  # Installation logic here
}

# Add to check_all_prerequisites()
check_newtool || missing+=("newtool")
```

### Adding New Stow Operations

To add new stow operations, edit `lib/stow.sh`:

```bash
# Example: Verify all symlinks
verify_all_symlinks() {
  local dotfiles_dir=$1
  # Verification logic here
}
```

## Architecture

```
scripts/
├── install.sh          # Main installation orchestrator
├── update.sh           # Update orchestrator
├── lib/
│   ├── colors.sh       # Output formatting
│   ├── utils.sh        # Common utilities
│   ├── checks.sh       # Prerequisite management
│   └── stow.sh         # Stow operations
└── README.md           # This file
```

Each script sources the libraries and uses modular functions for maintainability.

## Contributing

When modifying scripts:

1. Test with `--dry-run` first
2. Ensure idempotency (safe to run multiple times)
3. Provide clear error messages
4. Update this README if adding features
5. Follow existing code style and patterns

## License

Part of the dotfiles repository. Use freely.
