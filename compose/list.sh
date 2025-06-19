#!/bin/bash
set -euo pipefail

WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"

# Check if file exists or is empty
if [ ! -f "$WORKDIRS_FILE" ] || [ ! -s "$WORKDIRS_FILE" ]; then
    echo "No workdirs configured"
    exit 0
fi

# Display workdirs compactly
count=$(wc -l < "$WORKDIRS_FILE")
printf "Workdirs (%d): " "$count"
while IFS= read -r dir; do
    [[ -n "$dir" ]] && printf "%s%s " "$([ -d "$dir" ] && echo "✓" || echo "✗")" "$(basename "$dir")"
done < "$WORKDIRS_FILE"
echo
