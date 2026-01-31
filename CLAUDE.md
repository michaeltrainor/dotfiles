# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository using GNU Stow for symlink management. Each top-level directory represents a stow package that gets symlinked to the home directory.

## Installation

### Quick Start (macOS only)

```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Run installation (checks and installs prerequisites)
make install

# Follow prompts to install missing prerequisites
# Restart terminal when complete
exec zsh
```

### Prerequisites

The installation script checks and helps install:
- **Xcode Command Line Tools** (manual) - Script guides installation
- **Homebrew** (auto-installable) - Script can install automatically
- **GNU Stow** (auto-installable) - Installed via Homebrew
- **Rust** (manual via rustup) - Script guides installation
- **Go** (manual) - Script guides installation from golang.org
- **Pyenv** (manual via git clone) - Script guides installation from github.com/pyenv/pyenv

### Installation Options

```bash
# Preview installation without changes
make dry-run

# Install specific packages only
./scripts/install.sh --packages zsh,nvim,git

# Auto-backup conflicting files
./scripts/install.sh --backup
```

### Updating

```bash
# Interactive update (prompts for confirmation)
make update

# Non-interactive update
./scripts/update.sh --force

# Update specific packages only
./scripts/update.sh --packages zsh,nvim
```

For detailed documentation, see [scripts/README.md](scripts/README.md).

## Dotfiles Architecture

### Stow Package Structure

Each package directory follows the stow convention where the directory structure mirrors the target location in `$HOME`:

```
<package>/                 # Package name (e.g., zsh, nvim, git)
  └── .config/<package>/   # XDG Base Directory config
  └── .<rc-file>          # Home directory dotfile
```

Examples:
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `zsh/.zshrc` → `~/.zshrc`
- `git/.config/git/config` → `~/.config/git/config`

### Key Packages

- **zsh**: Shell configuration with Zinit plugin manager, includes `.zshrc` (interactive), `.zshenv` (environment), and `.zsh-helpers` (platform detection)
- **nvim**: Neovim configuration using lazy.nvim plugin manager, structured under `lua/mtd3v/` modules
- **git**: Git configuration with local override support via `config.local` (not tracked)
- **ghostty**: Terminal emulator configuration
- **starship**: Cross-shell prompt configuration
- **opencode**: OpenCode AI configuration
- **bat, eza, bottom, lazygit**: CLI tool configurations

### Neovim Structure

- Entry point: `nvim/.config/nvim/init.lua`
- Custom modules: `nvim/.config/nvim/lua/mtd3v/`
  - `options.lua`: Vim options
  - `keymap.lua`: Key mappings
  - `commands.lua`: Custom commands
  - `plugins/`: Plugin specifications for lazy.nvim
- Plugin manager: lazy.nvim (auto-installed on first run)
- Lock file: `lazy-lock.json` (gitignored)

### Zsh Configuration

- `.zshenv`: Loaded for all shells, sets up PATH and environment variables (cross-platform Homebrew detection)
- `.zshrc`: Interactive shell config, includes Zinit plugins (zsh-autosuggestions, fast-syntax-highlighting)
- `.zsh-helpers`: Platform detection utilities
- Plugin manager: Zinit (auto-installed on first use)

### Git Configuration

Uses include directive to separate tracked and local config:
- `git/.config/git/config`: Tracked configuration (includes delta pager, aliases, etc.)
- `~/.config/git/config.local`: Personal user data (name, email) - not tracked
- `git/.config/git/config.local.template`: Template for local config

## Common Commands

### Installation & Updates

```bash
# Full installation (first time)
make install

# Update existing installation
make update

# Preview installation
make dry-run

# Show all available commands
make help
```

### Package Management

```bash
# Install all Homebrew dependencies
brew bundle install

# Update Homebrew dependencies
brew bundle install --force

# Remove unused packages
brew bundle cleanup
```

### Stow Operations

```bash
# Deploy a package (from repository root)
stow <package-name>

# Deploy all packages
stow */

# Remove a package
stow -D <package-name>

# Dry run to see what would be symlinked
stow -n <package-name>

# Via Makefile
make stow      # Stow all packages
make unstow    # Unstow all packages
make restow    # Restow all packages (refresh)
```

### Neovim

```bash
# Format Lua files with stylua
stylua nvim/.config/nvim/

# Lint shell scripts
shellcheck <script.sh>
```

## Development Patterns

### Local Overrides

The repository supports local overrides via `*.local` files (gitignored):
- Git: `~/.config/git/config.local` for user-specific git config
- Any package can use `*.local` pattern for machine-specific overrides

### Cross-Platform Support

- Zsh configs include platform detection for macOS/Linux differences
- Homebrew setup handles Apple Silicon, Intel Mac, and Linux paths
- Platform-specific aliases in `.zshrc` (e.g., `finder`, clipboard commands)

### Theme Consistency

Repository uses TokyoNight color scheme across tools:
- Neovim: TokyoNight theme
- FZF: TokyoNight Storm colors
- Bat: TwoDark theme
- OpenCode: tokyonight theme
