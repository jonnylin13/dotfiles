#!/bin/sh

echo "Saving VSCode extensions..."
code --list-extensions > "$HOME"/dev/dotfiles/code_extensions
echo "Saved ✅ "
