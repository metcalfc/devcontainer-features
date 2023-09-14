#!/bin/sh
set -e

echo "Activating feature 'Atuin'"

COMPLETION=${COMPLETION:-true}
echo "Atuin completion files installed: $COMPLETION"

DIRECTORY=${HOME:-$_REMOTE_USER_HOME}

export DEBIAN_FRONTEND=noninteractive
apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

apt_get_update
check_packages curl ca-certificates

${PWD}/scripts/install-atuin.sh

mkdir -p /usr/local/share/atuin

cp ${PWD}/scripts/postAttachCommand.sh /usr/local/share/atuin/postAttachCommand.sh
cp ${PWD}/scripts/setup-shell.sh /usr/local/share/atuin/setup-shell.sh
cp ${PWD}/scripts/bash-preexec.sh /usr/local/share/atuin/bash-preexec.sh
chmod +x /usr/local/share/atuin/postAttachCommand.sh
chmod +x /usr/local/share/atuin/setup-shell.sh

if [ "$COMPLETION" = "true" ]; then
  mkdir -p /usr/share/bash-completion/completions
  /usr/bin/atuin gen-completions --shell bash > /usr/share/bash-completion/completions/atuin

  mkdir -p /usr/local/share/zsh/site-functions
  /usr/bin/atuin gen-completions --shell zsh > /usr/local/share/zsh/site-functions/_atuin

  mkdir -p /usr/share/fish/vendor_completions.d
  /usr/bin/atuin gen-completions --shell fish > /usr/share/fish/vendor_completions.d/atuin.fish

  echo "/usr/local/share/atuin/setup-shell.sh ${DIRECTORY}" >> /usr/local/share/atuin/postAttachCommand.sh
fi

# Clean up
rm -rf /var/lib/apt/lists/* /tmp/atuin
