#!/bin/sh

echo "Saving VSCode extensions..."
code --list-extensions > "$HOME/dev/dotfiles/config/vscode/extensions.txt"
echo "Saved VSCode extensions ✅ "
