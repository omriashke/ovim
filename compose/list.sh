#!/usr/bin/env bash
set -euo pipefail

SHOW_FULL_PATH=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --path)
            SHOW_FULL_PATH=true
            ;;
        *)
            echo "Unknown argument: $arg"
            exit 1
            ;;
    esac
done

WORKDIRS_FILE="${DEV_DIR:-}/compose/workdirs.txt"

# Check if file exists or is empty
if [ ! -f "$WORKDIRS_FILE" ] || [ ! -s "$WORKDIRS_FILE" ]; then
    echo "No workdirs configured"
    exit 0
fi

# Display workdirs line-by-line
count=$(wc -l < "$WORKDIRS_FILE" | xargs)
echo "Workdirs ($count):"
while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    STATUS=$([ -d "$dir" ] && echo "✓" || echo "✗")
    NAME=$([[ "$SHOW_FULL_PATH" == true ]] && echo "$dir" || basename "$dir")
    echo "  $STATUS $NAME"
done < "$WORKDIRS_FILE"
