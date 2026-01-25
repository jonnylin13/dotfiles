#!/usr/bin/env bash
set -e

# --- Install extensions ---
cat ./config/vscode/extensions.txt | xargs -n 1 code --install-extension

# --- Resolve VS Code user dir (portable) ---
VSCODE_USER="~/Library/Application Support/Code"
mkdir -p "$VSCODE_USER"

# --- Symlink config ---
ln -sf "$PWD/config/vscode/settings.json" "$VSCODE_USER/settings.json"
ln -sf "$PWD/config/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

echo "Done ✅ VS Code configured"
