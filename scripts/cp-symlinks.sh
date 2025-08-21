#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Copying symlinks from $SCRIPT_DIR/../symlinks to $SCRIPT_DIR/../"

for file in "$SCRIPT_DIR"/../symlinks/*; do
  if [ -L "$file" ]; then
    cp -L "$file" "$SCRIPT_DIR"/../
  fi
done

echo "Symlinks copied successfully."