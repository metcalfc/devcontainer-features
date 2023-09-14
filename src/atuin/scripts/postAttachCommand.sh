#!/bin/bash
set -e

# check a file for the given string if it exists do nothing. If it doesn't exist, add the string to the file.
checkFileForString() {
    if ! grep -sq "$1" "$2"; then
        echo "$1" >> "$2"
    fi
}

mkdir -p  ~/.config/atuin/

checkFileForString "sync_frequency = \"5m\""  ~/.config/atuin/config.toml

if [ -z "$ATUIN_USERNAME" ]; then
  echo "ATUIN_USERNAME not set. You'll need to login on your own."
  exit 0
fi

if [ -z "$ATUIN_PASSWORD" ]; then
  echo "ATUIN_PASSWORD not set. You'll need to login on your own."
  exit 0
fi

if [ -z "$ATUIN_KEY" ]; then
  echo "ATUIN_KEY not set. You'll need to login on your own."
  exit 0
fi

atuin login -u "$ATUIN_USERNAME" -p "$ATUIN_PASSWORD" --key "$ATUIN_KEY"
atuin sync
