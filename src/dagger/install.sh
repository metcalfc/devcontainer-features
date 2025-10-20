#!/bin/sh
set -e

echo "Activating feature 'Dagger'"

VERSION=${VERSION:-latest}
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

BIN_DIR="$LOCATION" ${PWD}/scripts/install-dagger.sh

chmod +x "$LOCATION/dagger"

mkdir -p /usr/local/share/dagger
cat <<EOF > /usr/local/share/dagger/postCreateCommand.sh
#!/bin/bash
set -e
if command -v pip &> /dev/null
then
  pip install dagger-io==${VERSION}
fi
EOF
chmod +x /usr/local/share/dagger/postCreateCommand.sh

if [ "$COMPLETION" = "true" ]; then
  mkdir -p /usr/share/bash-completion/completions
  "$LOCATION/dagger" completion bash > /usr/share/bash-completion/completions/dagger

  mkdir -p /usr/local/share/zsh/site-functions
  "$LOCATION/dagger" completion zsh > /usr/local/share/zsh/site-functions/_dagger

  mkdir -p /usr/share/fish/vendor_completions.d
  "$LOCATION/dagger" completion fish > /usr/share/fish/vendor_completions.d/dagger.fish

fi

# Clean up
rm -rf /var/lib/apt/lists/*