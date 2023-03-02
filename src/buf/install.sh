#!/bin/sh
set -e

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            echo "Running apt-get update..."
            apt-get update -y
        fi
        apt-get -y install --no-install-recommends "$@"
    fi
}

echo "(*) Installing BUF..."

VERSION=${VERSION:-"latest"}
echo "The provided version is: $VERSION"

versionStr="1.15.0"
if [ "${VERSION}" != "latest" ]; then
    versionStr=-${VERSION}
fi

check_packages curl ca-certificates

echo "https://github.com/bufbuild/buf/releases/download/v${versionStr}/buf-$(uname -s)-$(uname -m)" > /usr/local/bin/version

BIN="/usr/local/bin" 
curl -sSL \
"https://github.com/bufbuild/buf/releases/download/v${versionStr}/buf-$(uname -s)-$(uname -m)" \
-o "${BIN}/buf" || exit 1

chmod +x "${BIN}/buf"
