#!/usr/bin/env bash
# ============================
# Color Output Utilities
# ============================

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# Symbols
readonly SUCCESS="${GREEN}[✓]${RESET}"
readonly ERROR="${RED}[✗]${RESET}"
readonly INFO="${BLUE}[→]${RESET}"
readonly WARNING="${YELLOW}[!]${RESET}"
readonly PROMPT="${CYAN}[?]${RESET}"

# Print functions
log_success() {
  echo -e "${SUCCESS} $*"
}

log_error() {
  echo -e "${ERROR} $*" >&2
}

log_info() {
  echo -e "${INFO} $*"
}

log_warning() {
  echo -e "${WARNING} $*"
}

log_prompt() {
  echo -e "${PROMPT} $*"
}

log_header() {
  echo ""
  echo -e "${BOLD}${CYAN}$*${RESET}"
  echo -e "${CYAN}$(printf '%.0s=' {1..60})${RESET}"
}

log_step() {
  echo ""
  echo -e "${BOLD}$*${RESET}"
}

# Spinner for long operations
show_spinner() {
  local pid=$1
  local message=$2
  local delay=0.1
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'

  while ps -p "$pid" > /dev/null 2>&1; do
    local temp=${spinstr#?}
    printf " [%c] %s" "$spinstr" "$message"
    spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\r"
  done
  printf "    \r"
}
