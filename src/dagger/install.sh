#!/bin/sh
set -e

echo "Activating feature 'Dagger'"

VERSION=${VERSION:-0.8.4}
echo "Dagger version will be: $VERSION"
LOCATION=${LOCATION:-/usr/local/bin}
echo "Dagger will be installed here: $LOCATION"
COMPLETION=${COMPLETION:-true}
echo "Dagger completion files installed: $COMPLETION"

ARCHITECTURE=$(uname -m)

if [ "$ARCHITECTURE" = "x86_64" ]; then
  ARCHITECTURE="amd64"
fi

if [ "$ARCHITECTURE" = "aarch64" ]; then
  ARCHITECTURE="arm64"
fi

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
check_packages wget coreutils ca-certificates

mkdir /tmp/dagger
cd /tmp/dagger

#wget -c "https://github.com/dagger/dagger/releases/download/$VERSION/dagger_${VERSION}_linux_${ARCHITECTURE}.tar.gz"  -O - | tar --directory "$LOCATION" -xz dagger
wget -O /tmp/dagger/dagger_v${VERSION}_linux_${ARCHITECTURE}.tar.gz "https://github.com/dagger/dagger/releases/download/v${VERSION}/dagger_v${VERSION}_linux_${ARCHITECTURE}.tar.gz"
wget -O /tmp/dagger/checksums.txt "https://github.com/dagger/dagger/releases/download/v${VERSION}/checksums.txt"

sha256sum -c checksums.txt --ignore-missing || (echo "Checksum failed. Exiting." && exit 1)

tar --directory "$LOCATION" -xzf "/tmp/dagger/dagger_v${VERSION}_linux_${ARCHITECTURE}.tar.gz" dagger

chmod +x "$LOCATION/dagger"

if [ "$COMPLETION" = "true" ]; then
  mkdir -p /usr/share/bash-completion/completions
  "$LOCATION/dagger" completion bash > /usr/share/bash-completion/completions/dagger

  mkdir -p /usr/local/share/zsh/site-functions
  "$LOCATION/dagger" completion zsh > /usr/local/share/zsh/site-functions/_dagger

  mkdir -p /usr/share/fish/vendor_completions.d
  "$LOCATION/dagger" completion fish > /usr/share/fish/vendor_completions.d/dagger.fish

fi

# Clean up
rm -rf /var/lib/apt/lists/* /tmp/dagger
