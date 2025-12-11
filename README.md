# Dotfiles

Modern, cross-platform dotfiles for macOS and Linux. Organized using XDG Base Directory Standard with GNU Stow for symlink management.

## Features

- 🎨 **Consistent TokyoNight theme** across all tools
- 🔄 **Cross-platform** - Works on macOS (Intel & Apple Silicon) and Linux
- 📦 **Automated installation** with GNU Stow
- 🛠️ **Modern tools** - Neovim, Ghostty, Tmux, Zsh, Starship
- 🔒 **Secure** - Personal data separated in `.local` files
- 🧪 **Tested** - Docker-based cross-platform testing

## Tools Configured

### Shell & Terminal
- **Zsh** - Shell with Zinit plugin manager
- **Starship** - Modern, minimal prompt
- **Ghostty** - Modern terminal emulator
- **Tmux** - Terminal multiplexer with TPM

### Editor
- **Neovim** - Kickstart-based config with Lazy.nvim

### CLI Utilities
- **Git** - Modern config with Delta pager
- **Lazygit** - Git TUI
- **Eza** - Modern ls replacement
- **Bat** - Modern cat replacement
- **Bottom** - System monitor
- **FZF** - Fuzzy finder

### Development
- **Zed** - Modern code editor
- **OpenCode** - AI coding assistant

## Prerequisites

- **macOS** or **Linux** (Ubuntu, Debian, Fedora, Arch)
- **Homebrew** ([install](https://brew.sh))
- **Git**
- **GNU Stow**

## Quick Install

```bash
# Clone repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Install dependencies
brew bundle install

# Install dotfiles with Stow
stow zsh
stow git
stow nvim
stow tmux
stow ghostty
stow starship
stow bat
stow eza
stow bottom
stow lazygit
stow zed
stow opencode

# Run post-install setup
./scripts/post-stow.sh

# Set up Git personal data
cp git/.config/git/config.local.template ~/.config/git/config.local
# Edit ~/.config/git/config.local with your information

# Reload shell
exec zsh
```

## Installation Details

### macOS

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
cd ~/.dotfiles
brew bundle install

# Stow individual configs
stow zsh git nvim tmux ghostty starship bat eza bottom lazygit zed opencode
```

### Linux

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Install dependencies
cd ~/.dotfiles
brew bundle install

# Additional Linux packages (for clipboard support)
# Ubuntu/Debian
sudo apt-get install xclip

# Fedora
sudo dnf install xclip

# Arch
sudo pacman -S xclip

# Stow configs
stow zsh git nvim tmux ghostty starship bat eza bottom lazygit zed opencode
```

## Directory Structure

```
~/.dotfiles/
├── bat/              # Bat (cat replacement)
├── bottom/           # Bottom (system monitor)
├── eza/              # Eza (ls replacement)
├── ghostty/          # Ghostty terminal
├── git/              # Git configuration
├── lazygit/          # Lazygit TUI
├── nvim/             # Neovim editor
├── opencode/         # OpenCode AI
├── scripts/          # Installation scripts
├── starship/         # Starship prompt
├── tmux/             # Tmux multiplexer
├── zed/              # Zed editor
├── zsh/              # Zsh shell
├── Brewfile          # Homebrew dependencies
├── AGENTS.md         # AI agent documentation
└── README.md         # This file
```

## Customization

### Local Overrides

Create `.local` files for machine-specific settings:

```bash
# Git personal data
~/.config/git/config.local

# Zsh local settings
~/.zshrc.local
```

### Theme Customization

All tools use TokyoNight Storm theme. To change:

1. **Neovim**: Edit `nvim/.config/nvim/lua/mtd3v/plugins/kickstart.lua`
2. **Ghostty**: Change `theme` in `ghostty/.config/ghostty/config`
3. **Tmux**: Change plugin in `tmux/.tmux.conf`
4. **Starship**: Change palette in `starship/.config/starship.toml`

### Adding New Tools

```bash
# Create tool directory
mkdir -p newtool/.config/newtool

# Add configuration files
# ...

# Stow the configuration
stow newtool
```

## Platform-Specific Features

### macOS
- Finder integration (`finder` alias)
- DNS flush shortcuts
- Ghostty native titlebar styling

### Linux
- xclip clipboard support (`pbcopy`/`pbpaste` aliases)
- Cross-distribution package manager support

## Testing

Test dotfiles in clean Linux environments using Docker:

```bash
# Test on specific distribution
./test-docker.sh ubuntu
./test-docker.sh debian
./test-docker.sh fedora
./test-docker.sh arch

# Test on all distributions
./test-docker.sh all
```

## Post-Install Setup

After stowing configs:

1. **Set Git personal data**:
   ```bash
   cp git/.config/git/config.local.template ~/.config/git/config.local
   nano ~/.config/git/config.local
   ```

2. **Install Tmux plugins**:
   ```bash
   tmux source ~/.tmux.conf
   # Press: prefix + I (capital i)
   ```

3. **Install Neovim plugins** (automatic on first launch):
   ```bash
   nvim
   ```

## Updating

```bash
cd ~/.dotfiles
git pull
brew bundle install  # Update dependencies
./scripts/post-stow.sh
```

## Uninstalling

```bash
cd ~/.dotfiles
stow -D zsh git nvim tmux ghostty starship bat eza bottom lazygit zed opencode
```

## Troubleshooting

### Homebrew not found
- **macOS**: Ensure Homebrew is in PATH. Restart terminal.
- **Linux**: Run `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"`

### Stow conflicts
```bash
# Force restow (overwrites existing symlinks)
stow -R zsh

# Check what would be stowed
stow -n zsh
```

### Zsh configuration not loading
```bash
# Check if .zshenv is sourced
echo $PATH

# Manually source
source ~/.zshenv
source ~/.zshrc
```

### TPM plugins not installing
```bash
# Manually install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install plugins
~/.tmux/plugins/tpm/bin/install_plugins
```

## Key Bindings

### Tmux
- **Prefix**: `Ctrl+a`
- **Split horizontal**: `prefix + _`
- **Split vertical**: `prefix + -`
- **Navigate panes**: `prefix + h/j/k/l`
- **Install plugins**: `prefix + I`

### Neovim
- **Leader**: `Space`
- **File explorer**: `Space + -` (Oil.nvim)
- See `nvim/.config/nvim/lua/mtd3v/keymap.lua` for all mappings

## Resources

- [Neovim Kickstart](https://github.com/nvim-lua/kickstart.nvim)
- [Starship](https://starship.rs/)
- [TokyoNight Theme](https://github.com/folke/tokyonight.nvim)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Homebrew](https://brew.sh)

## License

MIT License - Feel free to use and modify for your own dotfiles!

## Credits

Inspired by:
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [holman/dotfiles](https://github.com/holman/dotfiles)
- [thoughtbot/dotfiles](https://github.com/thoughtbot/dotfiles)
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
