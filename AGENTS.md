# AGENTS.md

AI Agent Guide for Managing This Dotfiles Repository

## Repository Overview

This is a personal dotfiles repository using XDG Base Directory Standard organization. It contains configurations for terminal environments, development tools, and shell customizations. This is **not an application** - it is a collection of configuration files with no build artifacts or runtime.

**Primary Tools Configured:**
- **Terminals**: Ghostty, Alacritty
- **Shell**: Zsh (Zinit, Starship prompt)
- **Editors**: Neovim (Lazy.nvim, kickstart-based)
- **Multiplexer**: Tmux (TPM plugins)
- **Git Tools**: Git, Lazygit
- **CLI Utilities**: Eza, Bat, Bottom, FZF, Aerospace
- **AI Tools**: Continue.dev

## Directory Structure

```
~/.dotfiles/
├── <tool>/                  # Tool-specific directory
│   ├── .config/<tool>/     # XDG-compliant config location
│   │   └── config-files    # Actual configuration files
│   └── .<dotfile>          # Root-level dotfiles (e.g., .tmux.conf)
├── .gitignore              # macOS and system files exclusions
└── AGENTS.md               # This file
```

**Organization Pattern**: Each tool has its own directory containing either:
1. `.config/<tool>/` subdirectory (XDG standard) - preferred
2. Root-level dotfiles (e.g., `.tmux.conf`, `.zshrc`) - legacy compatibility

**Symlink Management**: Files should be symlinked to `$HOME` maintaining their relative structure. For example:
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `tmux/.tmux.conf` → `~/.tmux.conf`
- `zsh/.zshrc` → `~/.zshrc`

## Installation & Setup

**Current State**: No automated installation script exists. Manual setup required.

**Manual Installation Pattern**:
```bash
# XDG configs
ln -sf ~/.dotfiles/<tool>/.config/<tool> ~/.config/<tool>

# Root-level dotfiles
ln -sf ~/.dotfiles/<tool>/.<dotfile> ~/.<dotfile>
```

**Package Manager**: Homebrew (macOS)

**External Dependencies**:
- **Zinit**: Auto-installed via `.zshrc` on first run
- **TPM**: Tmux Plugin Manager (install: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`)
- **Lazy.nvim**: Auto-installed via `init.lua` on first Neovim launch
- **Starship**: Shell prompt (install: `brew install starship`)
- **FZF**: Fuzzy finder (install: `brew install fzf`)
- **Eza**: Modern `ls` replacement (install: `brew install eza`)
- **Pyenv**: Python version manager
- **NVM**: Node version manager

## File Format & Style Guidelines

### Universal Principles
- **Preservation First**: Always preserve existing comments, structure, and formatting
- **Read Before Write**: Never edit without first reading the file
- **Exact Matching**: Use precise string matching for edits, never placeholders
- **Syntax Validation**: Validate configuration syntax after any modification
- **No Secrets**: Never commit API keys, tokens, or personal credentials

### Format-Specific Standards

#### TOML (Alacritty, Aerospace, Ghostty, Bat, Bottom, Starship, StyLua)
```toml
# 2-space indentation
# Sort keys alphabetically within sections
# No trailing commas
# Use double quotes for strings
# Comment-first style for section headers

[section]
  key = "value"
  numeric-key = 42
```

**Tools**: Alacritty, Aerospace, Ghostty, Bat, Bottom, Starship, `.stylua.toml`

#### YAML (Lazygit, Zellij)
```yaml
# 2-space indentation
# Consistent spacing around colons
# Preserve comment blocks
# Use single quotes for strings unless escaping needed

section:
  key: 'value'
  nested:
    - item1
    - item2
```

**Tools**: Lazygit, Zellij config

#### JSON (Continue.dev, OpenCode)
```json
{
  "key": "value",
  "array": [1, 2, 3],
  "nested": {
    "key": "value"
  }
}
```

**Formatting**: 2-space indent, sorted keys, no trailing commas (strict JSON)

**Tools**: Continue.dev configs, OpenCode settings

#### JSONC (OpenCode)
```jsonc
{
  // Comments allowed
  "key": "value",
  "trailing": "comma allowed",
}
```

**Tools**: `opencode.jsonc`

#### Lua (Neovim)
```lua
-- Kickstart.nvim style conventions
-- https://github.com/nvim-lua/kickstart.nvim

-- Naming conventions
local snake_case_variables = true
local function snake_case_functions() end
local PascalCaseModules = require 'module.name'

-- Plugin management: Lazy.nvim
require('lazy').setup({
  require 'mtd3v.plugins.plugin-name',
}, {})

-- Use existing patterns
-- Preserve autocmds, keymaps, options structure
-- No parentheses for single-argument functions (stylua config)
-- Single quotes preferred (stylua config)
-- 2-space indentation
```

**Directory Structure**:
```
nvim/.config/nvim/
├── init.lua                # Entry point, loads modules
├── lua/mtd3v/              # Main configuration namespace
│   ├── plugins/            # Plugin configurations
│   │   ├── kickstart.lua   # Kickstart.nvim plugins
│   │   └── oil.lua         # Additional plugins
│   ├── commands.lua        # Custom commands
│   ├── keymap.lua          # Key mappings
│   └── options.lua         # Vim options
└── .stylua.toml            # Lua formatting config
```

**Formatting Tool**: `stylua nvim/` (respects `.stylua.toml`)

**Key Conventions**:
- Leader key: `<Space>`
- Local leader: `<Space>`
- Plugin manager: Lazy.nvim
- No Nerd Font icons in base config
- Modular plugin organization

#### GLSL (Ghostty Shaders)
```glsl
// Match existing shader patterns in ghostty/.config/ghostty/shaders/

// Standard uniforms used across shaders
uniform float u_time;           // Animation time
uniform vec2 u_resolution;      // Screen resolution
uniform vec2 u_mouse;           // Mouse position
uniform sampler2D u_texture;    // Terminal texture

void main() {
    // Shader logic
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec4 color = texture2D(u_texture, uv);
    gl_FragColor = color;
}
```

**Location**: `ghostty/.config/ghostty/shaders/`

**Conventions**:
- Uniform variable naming: `u_variableName`
- Follow existing patterns in shader collection
- Include descriptive comments for complex effects
- Test shader performance impact

#### TypeScript (Continue.dev)
```typescript
// Strict typing required
// Follow existing patterns in config.ts

interface Config {
  property: string
  optional?: number
}

const config: Config = {
  property: 'value',
}

export default config
```

**Files**: `continue.dev/.continue/config.ts`, `continue.dev/.continue/.continuerc.json`

**Conventions**:
- Strict TypeScript mode
- Interface over type when possible
- Follow Continue.dev API patterns
- Preserve existing configuration structure

#### Shell Scripts (Zsh, Bash)
```bash
#!/usr/bin/env zsh
# or
#!/usr/bin/env bash

# POSIX-compliant when possible
# Use shellcheck for validation
# Double-quote variable expansions
# Prefer [[ ]] over [ ] in bash/zsh

command -v tool >/dev/null && echo "Tool found"

if [[ -d "$HOME/.config" ]]; then
  echo "Config directory exists"
fi
```

**Key Files**:
- `zsh/.zshrc` - Interactive shell configuration
- `zsh/.zshenv` - Environment variables (sourced always)
- `zsh/.zprofile` - Login shell configuration

**Zsh-Specific**:
- Plugin manager: Zinit
- Prompt: Starship
- Completions: `compinit` via Zinit
- History: Shared across sessions, 1M entries

#### Git Config
```ini
[section]
	key = value
	another-key = value
[another-section]
	key = value
```

**Location**: `git/.config/git/config`

**Note**: Contains personal user information - handle with care

### Import/Require Ordering
```
1. Standard library imports
2. Third-party imports
3. Local/relative imports

# Lua example
local vim_api = vim.api                    -- Standard
local telescope = require 'telescope'      -- Third-party
local custom = require 'mtd3v.custom'      -- Local
```

## Testing & Validation

### No Build Process
This repository has **no build step**. Configurations are used directly by their respective tools.

### Validation Tools

#### Lua (Neovim)
```bash
# Format check (dry-run)
stylua --check nvim/

# Format files
stylua nvim/

# Neovim syntax check
nvim --headless -c "lua vim.health.check('init')" -c "quit"
```

**Config**: `nvim/.config/nvim/.stylua.toml`

#### Shell Scripts
```bash
# Install shellcheck
brew install shellcheck

# Validate zsh files
shellcheck zsh/.zshrc zsh/.zshenv zsh/.zprofile
```

#### TOML/YAML/JSON
```bash
# Python for TOML
python3 -m toml.decoder < file.toml

# yq for YAML
brew install yq
yq eval file.yaml

# jq for JSON
brew install jq
jq . file.json
```

### Manual Testing
Each configuration should be tested by:
1. **Symlinking** to appropriate location
2. **Reloading** the tool (or restarting)
3. **Verifying** expected behavior
4. **Checking** for error messages

### Pre-Commit Hooks
None currently configured. Consider adding:
- Syntax validation for each config type
- StyLua for Neovim configs
- Shellcheck for shell scripts
- Prevent committing secrets

## Agent Operating Principles

### 1. Research Before Action
- **Read files** before editing (mandatory)
- **Understand context** of surrounding code
- **Check dependencies** between configuration sections
- **Review tool documentation** when uncertain

### 2. Safe Editing Practices
- **Preserve structure**: Keep comments, whitespace, and organization
- **Atomic changes**: One logical change per edit
- **Exact matching**: Use sufficient context for unique identification
- **Validation**: Check syntax after modifications
- **Rollback plan**: Know how to undo changes

### 3. Tool-Specific Awareness

#### Neovim
- Lazy.nvim manages plugins asynchronously
- `:checkhealth` reveals configuration issues
- Leader key mappings use `<leader>` prefix (Space)
- Lua modules are cached - may need restart to test

#### Zsh
- Changes require: `source ~/.zshrc` or new shell
- Zinit handles plugin loading and updates
- PATH modifications go in `.zshenv` (not `.zshrc`)
- Completions load after all plugins

#### Tmux
- Reload config: `tmux source-file ~/.tmux.conf` or `prefix + r`
- TPM plugins install: `prefix + I`
- Changes to `@plugin` directives need TPM install

#### Ghostty
- Config changes apply to new windows/terminals
- Shader changes require terminal restart
- Invalid config silently falls back to defaults

### 4. Cross-Platform Considerations

**Current Platform**: macOS (Darwin)

**Platform-Specific Elements**:
- Homebrew package manager (macOS)
- macOS-specific settings (Ghostty titlebar, window management)
- `.DS_Store` and macOS artifacts in `.gitignore`

**Portability Guidelines**:
- Use `command -v` for tool detection
- Avoid hardcoded paths (use `$HOME`, `$XDG_CONFIG_HOME`)
- Conditionally load platform-specific configs
- Document macOS-specific requirements

### 5. Version Control Hygiene

**Commit Message Style**:
```
<type>(<scope>): <description>

# Examples
feat(nvim): add oil.nvim for file navigation
fix(zsh): correct fzf color scheme for catppuccin
refactor(ghostty): organize shaders by category
docs(agents): update installation instructions
```

**Types**: `feat`, `fix`, `refactor`, `docs`, `style`, `chore`

**Scope**: Tool name (nvim, zsh, tmux, ghostty, etc.)

**Commit Guidelines**:
- One logical change per commit
- Test before committing
- Never commit secrets or personal tokens
- Keep commits focused and atomic

### 6. Adding New Configurations

**Process**:
1. **Create tool directory**: `mkdir -p <tool>/.config/<tool>`
2. **Add configuration**: Place config files in appropriate location
3. **Document dependencies**: Note any required packages
4. **Update .gitignore**: Exclude generated/cache files
5. **Test manually**: Verify configuration works
6. **Update this guide**: Add to relevant sections

**Tool Directory Patterns**:
```bash
# XDG-compliant (preferred)
<tool>/.config/<tool>/config

# Legacy root dotfile
<tool>/.<dotfile>
```

### 7. Handling Secrets & Personal Data

**Current Personal Data**:
- Git: User name and email in `git/.config/git/config`
- Continue.dev: API keys may be in config (check `.continuerc.json`)

**Guidelines**:
- **Never commit**: API keys, tokens, passwords
- **Use environment variables**: For sensitive configuration
- **Create `.local` files**: For machine-specific overrides (add to `.gitignore`)
- **Mask in diffs**: Be cautious with git diff containing secrets

**Pattern for Local Overrides**:
```bash
# In main config file
if [[ -f "$HOME/.config/tool/config.local" ]]; then
  source "$HOME/.config/tool/config.local"
fi
```

### 8. Dependency Management

**System Dependencies** (via Homebrew):
- starship
- fzf
- eza
- bat
- bottom
- lazygit
- neovim
- tmux
- ghostty
- shellcheck (for validation)
- jq, yq (for config parsing)

**Language Version Managers**:
- **Pyenv**: Python versions
- **NVM**: Node.js versions (lazy-loaded in zsh)

**Auto-Installed**:
- Zinit (zsh plugin manager) - on first zsh launch
- Lazy.nvim (neovim plugin manager) - on first nvim launch
- TPM (tmux plugin manager) - manual: see Installation section

### 9. Performance Considerations

**Zsh**:
- Lazy-load heavy tools (NVM example in `.zshrc`)
- Minimize plugin count (currently: autosuggestions, syntax highlighting)
- Fast completion loading (`compinit -C`)

**Neovim**:
- Lazy.nvim loads plugins on demand
- Keep plugin count reasonable
- Profile with `:Lazy profile`

**Shell Startup Time**:
```bash
# Profile zsh
time zsh -i -c exit

# Profile nvim
nvim --startuptime startup.log
```

### 10. Documentation Standards

**Inline Comments**:
- Explain "why" not "what"
- Document non-obvious behavior
- Link to relevant documentation
- Note platform-specific sections

**This File (AGENTS.md)**:
- Keep updated with structural changes
- Document new tools added
- Update validation procedures
- Reflect actual repo state

**README.md** (if created):
- Overview of included tools
- Installation instructions
- Customization guide
- Screenshots/examples

## Common Tasks Reference

### Format Neovim Config
```bash
cd ~/.dotfiles
stylua nvim/
```

### Validate Shell Scripts
```bash
shellcheck zsh/.zshrc
```

### Test Configuration Changes

**Neovim**:
```bash
nvim --headless -c "lua print('OK')" -c quit
```

**Zsh**:
```bash
zsh -n ~/.dotfiles/zsh/.zshrc  # syntax check
```

**Tmux**:
```bash
tmux source-file ~/.tmux.conf  # reload
```

### Add New Plugin

**Neovim (Lazy.nvim)**:
```lua
-- In lua/mtd3v/plugins/plugin-name.lua
return {
  'author/plugin-name',
  config = function()
    require('plugin-name').setup {}
  end,
}
```

**Zsh (Zinit)**:
```bash
# In .zshrc
zinit light author/plugin-name
```

**Tmux (TPM)**:
```bash
# In .tmux.conf
set -g @plugin 'author/plugin-name'
```

### Check for Broken Symlinks
```bash
find ~ -maxdepth 3 -type l ! -exec test -e {} \; -print
```

## Tool-Specific Notes

### Neovim
- **Base**: kickstart.nvim patterns
- **Plugin Manager**: Lazy.nvim (auto-installs on first run)
- **Module Namespace**: `mtd3v.*`
- **Leader Keys**: Space (both leader and localleader)
- **Formatting**: StyLua with custom config

### Zsh
- **Plugin Manager**: Zinit (auto-installs)
- **Prompt**: Starship (requires `brew install starship`)
- **Theme**: Catppuccin colors for FZF
- **History**: Shared, 1M entries, ignores duplicates
- **Completions**: Docker, FZF, Zinit plugins

### Tmux
- **Plugin Manager**: TPM (manual install)
- **Prefix**: `C-a` (not default `C-b`)
- **Theme**: Gruvbox dark
- **Split Bindings**: `_` (horizontal), `-` (vertical)
- **Vim Navigation**: `h/j/k/l` for pane selection

### Ghostty
- **Theme**: TokyoNight Storm
- **Font**: Hack Nerd Font Mono, 14pt
- **Shaders**: Collection in `shaders/` directory
- **Opacity**: 90% with 80px blur
- **Integration**: Zsh with cursor control

### Git
- **Default Branch**: main
- **UI**: Column auto mode
- **User Config**: Personal name/email (handle with care)

### Continue.dev
- **Config Language**: TypeScript + JSON
- **Location**: `.continue/` directory
- **Sessions**: Stored in `sessions/`
- **Index**: LanceDB + SQLite for code context

## Troubleshooting

### Configuration Not Loading
1. Check symlink exists: `ls -la ~/.<dotfile>`
2. Verify symlink target: `readlink ~/.<dotfile>`
3. Check file permissions: `ls -l ~/.dotfiles/<tool>/.<dotfile>`
4. Review tool-specific error logs

### Neovim Issues
```bash
# Check health
:checkhealth

# Check Lazy.nvim status
:Lazy

# View messages
:messages

# Reload config
:source $MYVIMRC
```

### Zsh Not Loading Configs
```bash
# Check which files are sourced
zsh -o SOURCE_TRACE

# Verify .zshenv is in $HOME
ls -la ~/.zshenv

# Check Zinit installation
ls -la ~/.local/share/zinit/zinit.git
```

### Tmux Plugin Issues
```bash
# Verify TPM is installed
ls -la ~/.tmux/plugins/tpm

# Reload tmux config
tmux source-file ~/.tmux.conf

# Install plugins
# Press: <prefix> + I (capital i)
```

## Resources

### Official Documentation
- [XDG Base Directory Spec](https://specifications.freedesktop.org/basedir-spec/latest/)
- [Neovim](https://neovim.io/doc/) | [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Zinit](https://github.com/zdharma-continuum/zinit)
- [Tmux](https://github.com/tmux/tmux/wiki) | [TPM](https://github.com/tmux-plugins/tpm)
- [Starship Prompt](https://starship.rs/)
- [Ghostty](https://ghostty.org/)

### Dotfiles Inspiration
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [Mathias Bynens Dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Holman Dotfiles](https://github.com/holman/dotfiles)
- [Thoughtbot Dotfiles](https://github.com/thoughtbot/dotfiles)

### Validation Tools
- [StyLua](https://github.com/JohnnyMorganz/StyLua)
- [ShellCheck](https://www.shellcheck.net/)
- [yamllint](https://github.com/adrienverge/yamllint)

---

**Last Updated**: 2025-12-10
**Maintainer**: AI Agents + Manual Review
**Version**: 2.0.0

