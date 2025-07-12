#!/usr/bin/env bash
set -euo pipefail

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path1> [path2] [path3] ..."
    echo "Remove one or more paths from the workdirs.txt file"
    exit 1
fi

# Define the workdirs file path
WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"

# Check if file exists
if [ ! -f "$WORKDIRS_FILE" ]; then
    echo "Error: $WORKDIRS_FILE does not exist"
    exit 1
fi

# Create a temporary file
TEMP_FILE=$(mktemp)

# Copy the original file to temp
cp "$WORKDIRS_FILE" "$TEMP_FILE"

# Process each argument
for path in "$@"; do
    # Convert to absolute path if the directory exists
    if [ -d "$path" ]; then
        abs_path="$(realpath "$path")"
    else
        # If directory doesn't exist, try to remove the path as-is
        abs_path="$path"
    fi
    
    # Remove the path from temp file
    if grep -Fxq "$abs_path" "$TEMP_FILE"; then
        grep -Fxv "$abs_path" "$TEMP_FILE" > "${TEMP_FILE}.new" || true
        mv "${TEMP_FILE}.new" "$TEMP_FILE"
        echo "Removed: $abs_path"
    else
        echo "Path not found: $abs_path"
    fi
done

# Replace original file with modified temp file
mv "$TEMP_FILE" "$WORKDIRS_FILE"

# Check if file is empty and handle accordingly
if [ ! -s "$WORKDIRS_FILE" ]; then
    "$DEV_DIR/compose/down.sh"

    echo "Current workdirs: (file removed - was empty)"
else
    echo "Current workdirs:"
    cat "$WORKDIRS_FILE"
    
    # Execute generate.sh if it exists
    GENERATE_SCRIPT="$DEV_DIR/compose/generate.sh"
    if [ -f "$GENERATE_SCRIPT" ]; then
        echo "Executing $GENERATE_SCRIPT..."
        "$GENERATE_SCRIPT"
    else
        echo "Warning: $GENERATE_SCRIPT not found, skipping execution"
    fi
fi
