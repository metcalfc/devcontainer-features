#!/bin/bash
set -e

# check a file for the given string if it exists do nothing. If it doesn't exist, add the string to the file.
checkFileForString() {
    # make sure the directory exists
    dirname "$2" | xargs mkdir -p
    if ! grep -sq "$1" "$2"; then
        echo "$1" >> "$2"
    fi
}

if [ -z "$DOPPLER_TOKEN" ]; then
  echo "DOPPLER_TOKEN not set. You'll need to login on your own."
  exit 0
fi

doppler configure set token $DOPPLER_TOKEN

if [ -z "$DOPPLER_PROJECT" ]; then
  echo "DOPPLER_PROJECT not set. You'll need to login on your own."
  exit 0
fi

if [ -z "$DOPPLER_CONFIG" ]; then
  echo "DOPPLER_CONFIG not set. You'll need to login on your own."
  exit 0
fi

doppler setup --no-prompt --project "$DOPPLER_PROJECT" --config "$DOPPLER_CONFIG"
