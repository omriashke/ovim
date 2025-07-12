#!/usr/bin/env bash

set -euo pipefail

# ====== Load balancer Cloud-Init Script ======

# Versions and variables
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH_NAME=amd64
elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH_NAME=arm64
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Installing docker 
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do apt remove $pkg; done

# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

VERSION_STRING=5:28.1.1-1~debian.12~bookworm
apt-get install -y docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin docker-compose-plugin
