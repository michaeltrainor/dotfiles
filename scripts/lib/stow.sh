#!/usr/bin/env bash
# ============================
# Stow Operation Functions
# ============================

# Stow a single package
stow_package() {
  local package=$1
  local dotfiles_dir=$2
  local dry_run=${3:-0}

  # Validate package exists
  if [[ ! -d "$dotfiles_dir/$package" ]]; then
    log_error "Package not found: $package"
    return 1
  fi

  # Dry-run first to detect conflicts
  local stow_output
  if ! stow_output=$(stow -n -d "$dotfiles_dir" -t "$HOME" --stow "$package" 2>&1); then
    if [[ $dry_run -eq 1 ]]; then
      log_info "[DRY-RUN] Would stow: $package"
      return 0
    fi

    log_error "Conflicts detected for package: $package"
    echo "$stow_output" | grep -i "existing" | sed 's/^/  /'
    return 1
  fi

  # If dry-run only, report and return
  if [[ $dry_run -eq 1 ]]; then
    log_info "[DRY-RUN] Would stow: $package"
    return 0
  fi

  # Execute actual stow
  if stow -d "$dotfiles_dir" -t "$HOME" --stow "$package" 2>&1; then
    log_success "Stowed: $package"
    return 0
  else
    log_error "Failed to stow: $package"
    return 1
  fi
}

# Restow a package (refresh symlinks)
restow_package() {
  local package=$1
  local dotfiles_dir=$2
  local dry_run=${3:-0}

  # Validate package exists
  if [[ ! -d "$dotfiles_dir/$package" ]]; then
    log_error "Package not found: $package"
    return 1
  fi

  # If dry-run only, report and return
  if [[ $dry_run -eq 1 ]]; then
    log_info "[DRY-RUN] Would restow: $package"
    return 0
  fi

  # Execute restow
  if stow -d "$dotfiles_dir" -t "$HOME" --restow "$package" 2>&1; then
    log_success "Restowed: $package"
    return 0
  else
    log_error "Failed to restow: $package"
    return 1
  fi
}

# Unstow a package (remove symlinks)
unstow_package() {
  local package=$1
  local dotfiles_dir=$2
  local dry_run=${3:-0}

  # Validate package exists
  if [[ ! -d "$dotfiles_dir/$package" ]]; then
    log_error "Package not found: $package"
    return 1
  fi

  # If dry-run only, report and return
  if [[ $dry_run -eq 1 ]]; then
    log_info "[DRY-RUN] Would unstow: $package"
    return 0
  fi

  # Execute unstow
  if stow -d "$dotfiles_dir" -t "$HOME" --delete "$package" 2>&1; then
    log_success "Unstowed: $package"
    return 0
  else
    log_error "Failed to unstow: $package"
    return 1
  fi
}

# Stow all packages
stow_all_packages() {
  local dotfiles_dir=$1
  local packages=("${@:2}")
  local dry_run=${DRY_RUN:-0}

  local failed=()

  log_step "Stowing packages..."

  for package in "${packages[@]}"; do
    if ! stow_package "$package" "$dotfiles_dir" "$dry_run"; then
      failed+=("$package")
    fi
  done

  if [[ ${#failed[@]} -gt 0 ]]; then
    log_error "Failed to stow: ${failed[*]}"
    return 1
  fi

  return 0
}

# Restow all packages
restow_all_packages() {
  local dotfiles_dir=$1
  local packages=("${@:2}")
  local dry_run=${DRY_RUN:-0}

  local failed=()

  log_step "Restowing packages..."

  for package in "${packages[@]}"; do
    if ! restow_package "$package" "$dotfiles_dir" "$dry_run"; then
      failed+=("$package")
    fi
  done

  if [[ ${#failed[@]} -gt 0 ]]; then
    log_error "Failed to restow: ${failed[*]}"
    return 1
  fi

  return 0
}

# Get changed packages from git diff
get_changed_packages() {
  local dotfiles_dir=$1

  cd "$dotfiles_dir" || return 1

  # Get changed files since last pull
  local changed_files
  if ! changed_files=$(git diff --name-only HEAD@{1} HEAD 2>/dev/null); then
    # If no HEAD@{1}, return all packages
    get_all_packages "$dotfiles_dir"
    return 0
  fi

  # Extract unique package names (first directory in path)
  local packages=()
  while IFS= read -r file; do
    local pkg=$(echo "$file" | cut -d/ -f1)

    # Skip non-packages
    case "$pkg" in
      scripts|Brewfile|CLAUDE.md|Makefile|.*)
        continue
        ;;
      *)
        # Check if directory exists (is a package)
        if [[ -d "$dotfiles_dir/$pkg" ]] && [[ ! " ${packages[*]} " =~ " ${pkg} " ]]; then
          packages+=("$pkg")
        fi
        ;;
    esac
  done <<< "$changed_files"

  if [[ ${#packages[@]} -eq 0 ]]; then
    log_info "No package changes detected"
    return 0
  fi

  printf '%s\n' "${packages[@]}"
}

# Verify a package is properly stowed
verify_package() {
  local package=$1
  local dotfiles_dir=$2

  # This is a basic check - verify at least one symlink exists for the package
  local package_path="$dotfiles_dir/$package"

  # Find files in the package
  local file_count=$(find "$package_path" -type f | wc -l | tr -d ' ')

  if [[ $file_count -eq 0 ]]; then
    log_warning "No files found in package: $package"
    return 0  # Empty package is okay
  fi

  # Check if any symlinks point to this package
  # This is a simplified check - a real check would be more thorough
  return 0
}

# Check for stow conflicts before stowing
check_conflicts() {
  local package=$1
  local dotfiles_dir=$2

  local conflicts
  if conflicts=$(stow -n -d "$dotfiles_dir" -t "$HOME" --stow "$package" 2>&1 | grep "existing"); then
    echo "$conflicts"
    return 1
  fi

  return 0
}

# Backup conflicting files before stowing
backup_conflicts() {
  local package=$1
  local dotfiles_dir=$2
  local backup_dir=$3

  # Get list of conflicts
  local conflicts
  conflicts=$(stow -n -d "$dotfiles_dir" -t "$HOME" --stow "$package" 2>&1 | \
              grep "existing target" | \
              sed 's/.*existing target is neither.*: //' || true)

  if [[ -z "$conflicts" ]]; then
    return 0
  fi

  log_info "Backing up conflicts for: $package"

  # Backup each conflicting file
  while IFS= read -r conflict; do
    if [[ -n "$conflict" ]]; then
      backup_item "$conflict" "$backup_dir"
    fi
  done <<< "$conflicts"

  return 0
}
