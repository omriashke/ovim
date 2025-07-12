#!/usr/bin/env bash

OVIM_DIR="$HOME/.ovim"
export DEV_DIR="$OVIM_DIR"

# Clone or update the repository
INSTALL_DIR="$HOME/.ovim"
if [ -d "$INSTALL_DIR" ]; then
    echo "Updating ovim..."
    cd "$INSTALL_DIR" && git pull
else
    echo "Installing ovim..."
    git clone https://github.com/omriashkenazi/ovim.git "$INSTALL_DIR"
fi

# Make the main ovim script executable
chmod +x "$INSTALL_DIR/ovim"

# Make all compose scripts executable
chmod +x "$INSTALL_DIR"/compose/*.sh

# Add to PATH if not already there
SHELL_RC=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "export PATH=.*\.ovim" "$SHELL_RC"; then
        echo 'export PATH="$HOME/.ovim:$PATH"' >> "$SHELL_RC"
        echo "Added ovim to PATH in $SHELL_RC"
        echo "Please run: source $SHELL_RC"
    fi
fi

echo "ovim installed successfully!"
