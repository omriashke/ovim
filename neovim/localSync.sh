#!/usr/bin/env bash
# Define paths
SOURCE_DIR="$DEV_DIR/neovim"
TARGET_DIR="$HOME/.config/nvim"

# Remove specific files and directories
rm -f "$TARGET_DIR/init.lua"
rm -rf "$TARGET_DIR/lua"
rm -rf "$TARGET_DIR/after"

# Copy only the specific files and directories
cp "$SOURCE_DIR/init.lua" "$TARGET_DIR/init.lua" 2>/dev/null || echo "Warning: init.lua not found in source"
cp -r "$SOURCE_DIR/lua" "$TARGET_DIR/" 2>/dev/null || echo "Warning: lua directory not found in source"
cp -r "$SOURCE_DIR/after" "$TARGET_DIR/" 2>/dev/null || echo "Warning: after directory not found in source"
