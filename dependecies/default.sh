#!/usr/bin/env bash
set -euo pipefail

apt-get update

apt-get install -y ninja-build gettext make cmake build-essential ripgrep fd-find jq

# Install NVM
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load NVM and install Node
. "$NVM_DIR/nvm.sh"
nvm install 22
nvm alias default 22
nvm use 22

npm install -g corepack

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

git clone https://github.com/tree-sitter/tree-sitter /opt/tree-sitter
cd /opt/tree-sitter

make
cargo build --release

ln -s /opt/tree-sitter/target/release/tree-sitter /usr/local/bin/tree-sitter

cd /root/.local/share/nvim/site/pack/packer/start/blink.cmp

cargo build --release

# Install OpenTofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh

chmod +x install-opentofu.sh

./install-opentofu.sh --install-method deb

rm -f install-opentofu.sh
