#!/bin/bash

set -euo pipefail

apt update

apt install -y make cmake build-essential

git clone --depth=1 --branch stable https://github.com/neovim/neovim

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	~/.local/share/nvim/site/pack/packer/start/packer.nvim

cd neovim
git checkout stable
CMAKE_BUILD_TYPE=RelWithDebInfo
make install
