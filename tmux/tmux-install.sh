#!/usr/bin/env bash

set -euo pipefail

apt update

apt install -y tmux

mkdir -p ~/.tmux/plugins

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

mkdir -p ~/.config/tmux/plugins/catppuccin

git clone -b v2.1.3 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux

mkdir -p ~/.tmux/resurrect
