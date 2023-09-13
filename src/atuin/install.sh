#!/bin/sh
set -e

echo "Activating feature 'Atuin'"

COMPLETION=${COMPLETION:-true}
echo "Atuin completion files installed: $COMPLETION"


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

${PWD}/install-atuin.sh

mkdir -p /usr/local/share/atuin
cat <<EOF > /usr/local/share/atuin/postAttachCommand.sh
#!/bin/bash
set -e

if [ ! -f ~/.config/atuin/config.toml ]
then
  mkdir -p  ~/.config/atuin/
  echo "sync_frequency = \"5m\"" >> ~/.config/atuin/config.toml
fi

if [ -z "\$ATUIN_USERNAME" ]; then
  echo "ATUIN_USERNAME not set. You'll need to login on your own."
  exit 0
fi

if [ -z "\$ATUIN_PASSWORD" ]; then
  echo "ATUIN_PASSWORD not set. You'll need to login on your own."
  exit 0
fi

if [ -z "\$ATUIN_KEY" ]; then
  echo "ATUIN_KEY not set. You'll need to login on your own."
  exit 0
fi

atuin login -u "\$ATUIN_USERNAME" -p "\$ATUIN_PASSWORD" --key "\$ATUIN_KEY"
atuin sync
EOF

chmod +x /usr/local/share/atuin/postAttachCommand.sh

if [ "$COMPLETION" = "true" ]; then
  mkdir -p /usr/share/bash-completion/completions
  /usr/bin/atuin gen-completions --shell bash > /usr/share/bash-completion/completions/atuin

  mkdir -p /usr/local/share/zsh/site-functions
  /usr/bin/atuin gen-completions --shell zsh > /usr/local/share/zsh/site-functions/_atuin

  mkdir -p /usr/share/fish/vendor_completions.d
  /usr/bin/atuin gen-completions --shell fish > /usr/share/fish/vendor_completions.d/atuin.fish

fi



# Clean up
rm -rf /var/lib/apt/lists/* /tmp/atuin
