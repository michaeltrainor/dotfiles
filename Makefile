.PHONY: install update stow unstow restow dry-run clean help

# Default target
.DEFAULT_GOAL := help

install: ## Run full installation (bootstrap)
	@bash scripts/install.sh

update: ## Update existing installation
	@bash scripts/update.sh

stow: ## Stow all packages manually
	@stow */

unstow: ## Unstow all packages manually
	@stow -D */

restow: ## Restow all packages manually (refresh symlinks)
	@stow -R */

dry-run: ## Preview installation without making changes
	@bash scripts/install.sh --dry-run

clean: ## Show cleanup commands (manual review required)
	@echo "To remove dotfiles:"
	@echo "  make unstow"
	@echo ""
	@echo "To uninstall Homebrew packages:"
	@echo "  brew bundle cleanup --force"
	@echo ""
	@echo "To remove backup directories:"
	@echo "  rm -rf ~/.dotfiles-backup-*"

help: ## Show this help message
	@echo "Dotfiles Management Commands"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "For more options, see:"
	@echo "  scripts/install.sh --help"
	@echo "  scripts/update.sh --help"
