#!/bin/bash

set -euo pipefail

git clone --depth=1 --branch stable https://github.com/neovim/neovim

(
    cd neovim
    git checkout stable
    make CMAKE_BUILD_TYPE=Release
    make install
)

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
