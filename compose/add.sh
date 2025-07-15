#!/usr/bin/env bash
set -euo pipefail

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path1> [path2] [path3] ..."
    echo "Add one or more paths to the workdirs.txt file"
    exit 1
fi

# Define the workdirs file path
WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"

# Check if it exists and is a directory, then remove it
if [ -d "$WORKDIRS_FILE" ]; then
    echo "Removing directory: $WORKDIRS_FILE"
    rm -rf "$WORKDIRS_FILE"
fi

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$WORKDIRS_FILE")"

# Create the file if it doesn't exist
if [ ! -f "$WORKDIRS_FILE" ]; then
    touch "$WORKDIRS_FILE"
    echo "Created new workdirs file: $WORKDIRS_FILE"
fi

# Process each argument
for path in "$@"; do
    # Convert to absolute path
    if [ -d "$path" ]; then
        abs_path="$(realpath "$path")"
    else
        echo "Warning: Directory '$path' does not exist, skipping..."
        continue
    fi
    
    # Check if path already exists in file
    if grep -Fxq "$abs_path" "$WORKDIRS_FILE" 2>/dev/null; then
        echo "Path already exists: $abs_path"
    else
        echo "$abs_path" >> "$WORKDIRS_FILE"
        echo "Added: $abs_path"
    fi
done

# Sort and remove any duplicates that might have snuck in
sort -u "$WORKDIRS_FILE" -o "$WORKDIRS_FILE"

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
