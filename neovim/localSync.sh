#!/usr/bin/env bash

set -e

# Define paths
SOURCE_DIR="$DEV_DIR/neovim"
TARGET_DIR="$HOME/.config/nvim"

rm -rf "$TARGET_DIR"
cp -r "$SOURCE_DIR" "$TARGET_DIR"

nvim --headless +PackerClean +PackerSync +qa
