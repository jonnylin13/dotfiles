#!/usr/bin/env bash
set -e

# --- Install extensions ---
cat ./code_extensions | xargs -n 1 code --install-extension

# --- Resolve VS Code user dir (portable) ---
VSCODE_USER="~/Library/Application Support/Code"
mkdir -p "$VSCODE_USER"

# --- Symlink config ---
ln -sf "$PWD/settings.json" "$VSCODE_USER/settings.json"
ln -sf "$PWD/keybindings.json" "$VSCODE_USER/keybindings.json"

echo "Done ✅ VS Code configured"
