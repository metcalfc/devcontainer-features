#!/bin/bash
set -e

source dev-container-features-test-lib

check "doppler has installed the completion files for bash" bash -c "ls /usr/share/bash-completion/completions/doppler"
check "doppler has installed the completion files for zsh" bash -c "ls /usr/local/share/zsh/site-functions/_doppler"
check "doppler has installed the completion files for fish" bash -c "ls /usr/share/fish/vendor_completions.d/doppler.fish"

reportResults
