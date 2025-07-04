#!/usr/bin/env bash

# Define paths
SOURCE_DIR="$DEV_DIR/neovim"
TARGET_DIR="$HOME/.config/nvim"

rm -rf "$TARGET_DIR"
rm -f /root/.local/share/nvim/.packer_first_run
cp -r "$SOURCE_DIR" "$TARGET_DIR"
