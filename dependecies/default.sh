#!/usr/bin/env bash
set -e

apt update

apt install -y ninja-build gettext cmake curl build-essential ripgrep fd-find

# Install NVM
export NVM_DIR="$HOME/.nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Load NVM and install Node
. "$NVM_DIR/nvm.sh"
nvm install 22
nvm alias default 22
nvm use 22

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env

git clone https://github.com/tree-sitter/tree-sitter /opt/tree-sitter
cd /opt/tree-sitter

make
cargo build --release

ln -s /opt/tree-sitter/target/release/tree-sitter /usr/local/bin/tree-sitter
