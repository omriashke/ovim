#!/usr/bin/env bash
set -euo pipefail
# Read working directories from file
WORKDIR_FILE="$DEV_DIR/compose/workdirs.txt"
MOUNTS=""
# Check if file exists
if [ ! -f "$WORKDIR_FILE" ]; then
    echo "Error: $WORKDIR_FILE not found!"
    exit 1
fi
# Read each line from the file
while IFS= read -r dir; do
    # Skip empty lines and comments
    [[ -z "$dir" || "$dir" =~ ^[[:space:]]*# ]] && continue
    
    abs_path="$(cd "$dir" && pwd)"
    base_name="$(basename "$abs_path")"
    MOUNTS+="      - $abs_path:/root/$base_name\n"
done < "$WORKDIR_FILE"
# Inject volumes into template
awk -v mounts="$MOUNTS" '
BEGIN {found=0}
/^    volumes:/ {
    print
    printf "%s", mounts
    found=1
    next
}
{ print }
' "$DEV_DIR/compose/compose.template.yaml" > "$DEV_DIR/compose.yaml"
