#!/usr/bin/env bash
set -euo pipefail

# Colors and formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly GRAY='\033[0;90m'
readonly BOLD='\033[1m'
readonly RESET='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ${RESET} $1"; }
log_success() { echo -e "${GREEN}✓${RESET} $1"; }
log_warn() { echo -e "${YELLOW}⚠${RESET} $1"; }
log_error() { echo -e "${RED}✗${RESET} $1" >&2; }
log_dim() { echo -e "${GRAY}$1${RESET}"; }

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    log_error "No paths provided"
    echo "Usage: $0 <path1> [path2] [path3] ..."
    echo "Add one or more paths to the workdirs.txt file"
    exit 1
fi

# Define the workdirs file path
WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$WORKDIRS_FILE")"

# Create the file if it doesn't exist
if [ ! -f "$WORKDIRS_FILE" ]; then
    touch "$WORKDIRS_FILE"
    log_info "Created workdirs file"
fi

# Process each argument
added_count=0
skipped_count=0
duplicate_count=0

for path in "$@"; do
    # Convert to absolute path
    if [ -d "$path" ]; then
        abs_path="$(realpath "$path")"
    else
        log_warn "Directory '$path' does not exist, skipping"
        ((skipped_count++))
        continue
    fi
    
    # Check if path already exists in file
    if grep -Fxq "$abs_path" "$WORKDIRS_FILE" 2>/dev/null; then
        log_dim "Already exists: $(basename "$abs_path")"
        ((duplicate_count++))
    else
        echo "$abs_path" >> "$WORKDIRS_FILE"
        log_success "Added $(basename "$abs_path")"
        ((added_count++))
    fi
done

# Sort and remove any duplicates that might have snuck in
sort -u "$WORKDIRS_FILE" -o "$WORKDIRS_FILE"

# Summary
if [ $added_count -gt 0 ]; then
    log_success "Added $added_count path$([ $added_count -ne 1 ] && echo "s")"
fi
if [ $duplicate_count -gt 0 ]; then
    log_dim "Skipped $duplicate_count duplicate$([ $duplicate_count -ne 1 ] && echo "s")"
fi
if [ $skipped_count -gt 0 ]; then
    log_warn "Skipped $skipped_count missing director$([ $skipped_count -ne 1 ] && echo "ies" || echo "y")"
fi

# Show current workdirs only if there are any
if [ -s "$WORKDIRS_FILE" ]; then
    echo
    echo -e "${BOLD}Current workdirs:${RESET}"
    while IFS= read -r line; do
        echo -e "${GRAY}  $(basename "$line")${RESET}"
    done < "$WORKDIRS_FILE"
fi

# Execute generate.sh if it exists
GENERATE_SCRIPT="$DEV_DIR/compose/generate.sh"
if [ -f "$GENERATE_SCRIPT" ]; then
    echo
    log_info "Regenerating configuration..."
    if "$GENERATE_SCRIPT"; then
        log_success "Configuration updated"
    else
        log_error "Failed to update configuration"
        exit 1
    fi
else
    log_warn "Generator script not found: $GENERATE_SCRIPT"
fi
