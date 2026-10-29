#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${HOME}/dev/dotfiles"

echo "==> Saving VS Code extensions..."
if command -v code &>/dev/null; then
  code --list-extensions | grep -v "zscaler" | sort > "${DOTFILES_DIR}/config/vscode/extensions.txt"
  echo "Saved extensions to config/vscode/extensions.txt ✅"
else
  echo "VS Code CLI ('code') not found in PATH."
fi

echo "State saved successfully! ✅"
