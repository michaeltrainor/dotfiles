# macOS environment
export PATH="/usr/local/bin:/usr/local/sbin:/opt/homebrew/bin:$PATH"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export PAGER=less

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

# Added by swiftly
. "/Users/mtd3v/.swiftly/env.sh"