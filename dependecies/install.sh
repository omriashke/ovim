#!/usr/bin/env bash
set -euo pipefail

CLANG_VER="1:14.0-55.7~deb12u1"
NINJA_BUILD_VER="1.11.1-2~deb12u1"
GETTEXT_VER="0.21-12"
GIT_VER="1:2.39.5-0+deb12u2"
TMUX_VER="3.3a-3"
CURL_VER="7.88.1-10+deb12u14"
MAKE_VER="4.3-4.1"
CMAKE_VER="3.25.1-1"
BUILD_ESSENTIAL_VER="12.9"
RIPGREP_VER="13.0.0-4+b2"
FD_FIND_VER="8.6.0-3"
JQ_VER="1.6-2.1+deb12u1"
DOCKER_IO_VER="20.10.24+dfsg1-1+deb12u1+b2"

apt-get update
apt-get install -y \
  clang=$CLANG_VER \
  ninja-build=$NINJA_BUILD_VER \
  gettext=$GETTEXT_VER \
  git=$GIT_VER \
  tmux=$TMUX_VER \
  curl=$CURL_VER \
  make=$MAKE_VER \
  cmake=$CMAKE_VER \
  build-essential=$BUILD_ESSENTIAL_VER \
  ripgrep=$RIPGREP_VER \
  fd-find=$FD_FIND_VER \
  jq=$JQ_VER \
  docker.io=$DOCKER_IO_VER

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

# Install OpenTofu
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh

chmod +x install-opentofu.sh

./install-opentofu.sh --install-method deb

rm -f install-opentofu.sh

# Tmux
mkdir -p /root/.tmux/plugins

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p /root/.config/tmux/plugins/catppuccin

git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

mkdir -p /root/.tmux/resurrect

# Neovim
git clone --depth=1 --branch stable https://github.com/neovim/neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	~/.local/share/nvim/site/pack/packer/start/packer.nvim

cd neovim
git checkout stable
CMAKE_BUILD_TYPE=RelWithDebInfo
make install
