#!/bin/bash
set -e

source dev-container-features-test-lib

check "doppler has installed the completion files for bash" bash -c "ls /etc/bash_completion.d/doppler"
check "doppler has installed the completion files for zsh" bash -c "ls /usr/local/share/zsh/site-functions/_doppler"
# for some reason you can't install fish completions from a shell
# other than fish. So we'll skip until someone files an issue.
#check "doppler has installed the completion files for fish" bash -c "ls /usr/share/fish/vendor_completions.d/doppler.fish"

reportResults
