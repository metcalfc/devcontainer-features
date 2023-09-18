#!/bin/bash

set -e

DIRECTORY="${1:-$HOME}"

# check a file for the given string if it exists do nothing. If it doesn't exist, add the string to the file.
checkFileForString() {
    # make sure the directory exists
    dirname "$2" | xargs mkdir -p
    if ! grep -sq "$1" "$2"; then
        echo "$1" >> "$2"
    fi
}

case $(basename $SHELL) in
    bash)
        checkFileForString "source /usr/local/share/atuin/bash-preexec.sh" $DIRECTORY/.bashrc
        checkFileForString 'eval "$(atuin init bash)"' $DIRECTORY/.bashrc
        ;;
    zsh)
        checkFileForString 'eval "$(atuin init zsh)"' $DIRECTORY/.zshrc

        ;;
    fish)
        checkFileForString "atuin init fish | source" $DIRECTORY/.config/fish/config.fish
        ;;
esac
