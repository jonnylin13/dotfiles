#!/bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


for file in "$SCRIPT_DIR"/../symlinks/*; do
  if [ -L "$file" ]; then
    cp -L "$file" "$SCRIPT_DIR"/../
  fi
done