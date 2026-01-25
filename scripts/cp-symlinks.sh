#!/bin/sh
set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"

SRC="$SCRIPT_DIR/../symlinks"
DST="$SCRIPT_DIR/../config"

echo "Copying contents from $SRC to $DST (dereferencing symlinks)"

# Ensure destination exists
mkdir -p "$DST"

# Copy everything, preserving structure, following symlinks
rsync -aL --safe-links "$SRC"/ "$DST"/
echo "Symlinks copied successfully ✅"