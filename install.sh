#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Dotfiles One-Stop Installer
# ==============================================================================

DOTFILES_DIR="${HOME}/dev/dotfiles"
TIMESTAMP=''
BACKUP_DIR=""

DRY_RUN=false
SKIP_BREW=false
SKIP_VSCODE=false

# Parse flags
for arg in "$@"; do
  case "$arg" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --skip-brew)
      SKIP_BREW=true
      shift
      ;;
    --skip-vscode)
      SKIP_VSCODE=true
      shift
      ;;
    --help|-h)
      echo "Usage: ./install.sh [options]"
      echo ""
      echo "Options:"
      echo "  --dry-run      Preview actions without modifying the filesystem"
      echo "  --skip-brew    Skip Homebrew bundle installation"
      echo "  --skip-vscode  Skip installing VS Code extensions"
      echo "  --help, -h     Show this help message"
      exit 0
      ;;
  esac
done

echo "=================================================="
echo "  Setting up dotfiles from ${DOTFILES_DIR}"
echo "=================================================="

# ------------------------------------------------------------------------------
# 1. Helper Functions
# ------------------------------------------------------------------------------

log_info() {
  printf "\033[34m==>\033[0m %s\n" "$1"
}

log_success() {
  printf "\033[32m  ✔\033[0m %s\n" "$1"
}

log_warn() {
  printf "\033[33m  ⚠\033[0m %s\n" "$1"
}

get_backup_dir() {
  if [ -z "$BACKUP_DIR" ]; then
    BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
  fi
  printf "%s" "$BACKUP_DIR"
}

backup_and_link() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    log_warn "Source $src does not exist. Skipping."
    return
  fi

  # Check if already correctly linked
  if [ -L "$dest" ]; then
    local current_target
    current_target="$(readlink "$dest")"
    if [ "$current_target" = "$src" ]; then
      log_success "Already linked: $dest -> $src"
      return
    fi
  fi

  # Backup existing file/directory/symlink if present
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    local b_dir
    b_dir="$(get_backup_dir)"
    if [ "$DRY_RUN" = true ]; then
      printf "  [dry-run] Would backup: %s -> %s/\n" "$dest" "$b_dir"
    else
      local rel_path="${dest#"${HOME}/"}"
      local backup_target="${b_dir}/${rel_path}"
      mkdir -p "$(dirname "$backup_target")"
      mv "$dest" "$backup_target"
      log_warn "Backed up $dest -> $backup_target"
    fi
  fi

  # Create symlink
  if [ "$DRY_RUN" = true ]; then
    printf "  [dry-run] Would link: %s -> %s\n" "$dest" "$src"
  else
    mkdir -p "$(dirname "$dest")"
    ln -sfn "$src" "$dest"
    log_success "Linked: $dest -> $src"
  fi
}

ensure_local_file() {
  local file="$1"
  local template_content="$2"
  local perms="${3:-600}"

  if [ ! -f "$file" ]; then
    if [ "$DRY_RUN" = true ]; then
      printf "  [dry-run] Would create local file template: %s\n" "$file"
    else
      mkdir -p "$(dirname "$file")"
      printf "%s\n" "$template_content" > "$file"
      chmod "$perms" "$file"
      log_success "Created local template: $file"
    fi
  fi
}

# ------------------------------------------------------------------------------
# 2. Local Override Files (Private Secrets & Machine Configs)
# ------------------------------------------------------------------------------
log_info "Ensuring local override files exist..."

ensure_local_file "${HOME}/.zshrc.local" "# Machine-specific environment variables and secrets (DO NOT COMMIT)
# export ANTHROPIC_BASE_URL="http://localhost:8082"
# export ANTHROPIC_AUTH_TOKEN="..."
" 600

ensure_local_file "${HOME}/.zshenv.local" "# Machine-specific zshenv (DO NOT COMMIT)
" 600

ensure_local_file "${HOME}/.gitconfig.local" "# Machine-specific git config (DO NOT COMMIT)
# [user]
#     signingkey = ...
" 600

ensure_local_file "${HOME}/.ssh/config.local" "# Private / machine-specific SSH hosts (DO NOT COMMIT)
" 600

# ------------------------------------------------------------------------------
# 3. Create Symlinks
# ------------------------------------------------------------------------------
log_info "Linking configuration directories and files..."

# Neovim
backup_and_link "${DOTFILES_DIR}/config/nvim" "${HOME}/.config/nvim"

# Kitty
backup_and_link "${DOTFILES_DIR}/config/kitty" "${HOME}/.config/kitty"

# VS Code
VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
backup_and_link "${DOTFILES_DIR}/config/vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
backup_and_link "${DOTFILES_DIR}/config/vscode/keybindings.json" "${VSCODE_USER_DIR}/keybindings.json"

# Shell
backup_and_link "${DOTFILES_DIR}/config/zsh/.zshrc" "${HOME}/.zshrc"
backup_and_link "${DOTFILES_DIR}/config/zsh/.zshenv" "${HOME}/.zshenv"
backup_and_link "${DOTFILES_DIR}/config/zsh/.bash_profile" "${HOME}/.bash_profile"

# Git & SSH
backup_and_link "${DOTFILES_DIR}/config/git/.gitconfig" "${HOME}/.gitconfig"
backup_and_link "${DOTFILES_DIR}/config/ssh/config" "${HOME}/.ssh/config"

# ------------------------------------------------------------------------------
# 4. Homebrew Packages
# ------------------------------------------------------------------------------
if [ "$SKIP_BREW" = false ]; then
  log_info "Checking Homebrew packages..."
  if command -v brew &>/dev/null; then
    if [ "$DRY_RUN" = true ]; then
      printf "  [dry-run] Would execute: brew bundle --file=%s/Brewfile\n" "${DOTFILES_DIR}"
    else
      brew bundle --file="${DOTFILES_DIR}/Brewfile" || log_warn "brew bundle encountered warnings."
      log_success "Homebrew packages verified."
    fi
  else
    log_warn "Homebrew not found. Install from https://brew.sh and re-run install.sh"
  fi
fi

# ------------------------------------------------------------------------------
# 5. VS Code Extensions
# ------------------------------------------------------------------------------
if [ "$SKIP_VSCODE" = false ]; then
  log_info "Checking VS Code extensions..."
  if command -v code &>/dev/null && [ -f "${DOTFILES_DIR}/config/vscode/extensions.txt" ]; then
    if [ "$DRY_RUN" = true ]; then
      printf "  [dry-run] Would install extensions from %s/config/vscode/extensions.txt\n" "${DOTFILES_DIR}"
    else
      while IFS= read -r ext || [ -n "$ext" ]; do
        [ -z "$ext" ] && continue
        case "$ext" in
          \#*) continue ;;
        esac
        code --install-extension "$ext" --force &>/dev/null || true
      done < "${DOTFILES_DIR}/config/vscode/extensions.txt"
      log_success "VS Code extensions verified."
    fi
  else
    log_warn "VS Code CLI ('code') not found in PATH or extensions.txt missing."
  fi
fi

# ------------------------------------------------------------------------------
# 6. Git Pre-Commit Hook (Secret Protection)
# ------------------------------------------------------------------------------
log_info "Configuring Git hooks..."
HOOK_DIR="${DOTFILES_DIR}/.git/hooks"
if [ -d "$HOOK_DIR" ]; then
  HOOK_FILE="${HOOK_DIR}/pre-commit"
  if [ "$DRY_RUN" = true ]; then
    printf "  [dry-run] Would install gitleaks pre-commit hook in %s\n" "$HOOK_FILE"
  else
    cat << 'HOOK_EOF' > "$HOOK_FILE"
#!/usr/bin/env bash
if command -v gitleaks &>/dev/null; then
  gitleaks protect --staged -v
fi
HOOK_EOF
    chmod +x "$HOOK_FILE"
    log_success "Gitleaks pre-commit hook installed in .git/hooks/pre-commit"
  fi
fi

echo ""
echo "=================================================="
echo "  Dotfiles installation complete! 🎉"
echo "=================================================="
