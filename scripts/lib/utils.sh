#!/usr/bin/env bash
# ============================
# Common Utility Functions
# ============================

# Get the dotfiles directory (parent of scripts/)
get_dotfiles_dir() {
  cd "$(dirname "${BASH_SOURCE[1]}")/.." && pwd
}

# Prompt for yes/no confirmation
# Returns 0 for yes, 1 for no
prompt_confirm() {
  local message=$1
  local default=${2:-"y"}  # default to yes

  local prompt
  if [[ $default == "y" ]]; then
    prompt="[Y/n]"
  else
    prompt="[y/N]"
  fi

  log_prompt "$message $prompt"
  read -r response

  # Use default if empty
  response=${response:-$default}

  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Wait for user to press enter
wait_for_enter() {
  local message=${1:-"Press Enter to continue..."}
  log_prompt "$message"
  read -r
}

# Check if command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Backup a file or directory
backup_item() {
  local item=$1
  local backup_dir=$2

  if [[ -e "$item" ]] && [[ ! -L "$item" ]]; then
    local relative_path="${item#$HOME/}"
    local backup_path="$backup_dir/$relative_path"

    mkdir -p "$(dirname "$backup_path")"
    mv "$item" "$backup_path"
    log_info "Backed up: $relative_path"
    return 0
  fi

  return 1
}

# Count files in backup directory
count_backup_files() {
  local backup_dir=$1
  if [[ -d "$backup_dir" ]]; then
    find "$backup_dir" -type f | wc -l | tr -d ' '
  else
    echo "0"
  fi
}

# Die with error message
die() {
  log_error "$*"
  exit 1
}

# Check if running on macOS
is_macos() {
  [[ "$OSTYPE" == "darwin"* ]]
}

# Verify we're on macOS
require_macos() {
  if ! is_macos; then
    die "This script is designed for macOS only. Detected OS: $OSTYPE"
  fi
}

# Get list of stow packages (directories in dotfiles root)
get_all_packages() {
  local dotfiles_dir=$1
  local packages=()

  for dir in "$dotfiles_dir"/*/; do
    local dirname=$(basename "$dir")

    # Skip non-package directories
    case "$dirname" in
      scripts|.git|.*)
        continue
        ;;
      *)
        packages+=("$dirname")
        ;;
    esac
  done

  printf '%s\n' "${packages[@]}"
}

# Parse comma-separated package list
parse_package_list() {
  local package_string=$1
  echo "$package_string" | tr ',' '\n'
}

# Validate package exists
validate_package() {
  local package=$1
  local dotfiles_dir=$2

  if [[ ! -d "$dotfiles_dir/$package" ]]; then
    log_error "Package not found: $package"
    return 1
  fi

  return 0
}
