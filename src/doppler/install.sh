#!/bin/sh
set -e

echo "Activating feature 'doppler'"

COMPLETION=${COMPLETION:-true}
echo "doppler completion files installed: $COMPLETION"

# feature scripts run as root but we want to install doppler for the container
# or remote user
# https://containers.dev/implementors/features/#user-env-var
DIRECTORY="$_REMOTE_USER_HOME"

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
check_packages apt-transport-https ca-certificates curl gnupg


# Add Doppler's GPG key
curl -sLf --retry 3 --tlsv1.2 --proto "=https" 'https://packages.doppler.com/public/cli/gpg.DE2A7741A397C129.key' | apt-key add -

# Add Doppler's apt repo
echo "deb https://packages.doppler.com/public/cli/deb/debian any-version main" > /etc/apt/sources.list.d/doppler-cli.list

# Fetch and install latest doppler cli
apt-get update && apt-get install -y doppler

mkdir -p /usr/local/share/doppler
cp ${PWD}/scripts/setup-doppler.sh /usr/local/share/doppler/setup-doppler.sh
chmod +x /usr/local/share/doppler/setup-doppler.sh

if [ "$COMPLETION" = "true" ]; then
    apt-get install -y bash-completion

    mkdir -p /usr/share/bash-completion/completions
    doppler completion install bash

    mkdir -p /usr/local/share/zsh/site-functions
    doppler completion install zsh

    # for some reason you can't install fish completions from a shell
    # other than fish. So we'll skip until someone files an issue.
    #mkdir -p /usr/share/fish/vendor_completions.d
    #doppler completion install fish
fi

# Clean up
rm -rf /var/lib/apt/lists/* /tmp/doppler
