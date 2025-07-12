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
    echo "Remove one or more paths from the workdirs.txt file"
    exit 1
fi

# Define the workdirs file path
WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"

# Check if file exists
if [ ! -f "$WORKDIRS_FILE" ]; then
    log_error "Workdirs file not found: $WORKDIRS_FILE"
    exit 1
fi

# Create a temporary file
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT

# Copy the original file to temp
cp "$WORKDIRS_FILE" "$TEMP_FILE"

# Process each argument
removed_count=0
not_found_count=0

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
        log_success "Removed $(basename "$abs_path")"
        ((removed_count++))
    else
        log_dim "Not found: $(basename "$abs_path")"
        ((not_found_count++))
    fi
done

# Replace original file with modified temp file
mv "$TEMP_FILE" "$WORKDIRS_FILE"

# Summary
if [ $removed_count -gt 0 ]; then
    log_success "Removed $removed_count path$([ $removed_count -ne 1 ] && echo "s")"
fi
if [ $not_found_count -gt 0 ]; then
    log_dim "Skipped $not_found_count path$([ $not_found_count -ne 1 ] && echo "s") (not found)"
fi

# Check if file is empty and handle accordingly
if [ ! -s "$WORKDIRS_FILE" ]; then
    echo
    log_info "No workdirs remaining, shutting down services..."
    if "$DEV_DIR/compose/down.sh"; then
        log_success "Services stopped"
    else
        log_warn "Failed to stop services"
    fi
    rm -f "$WORKDIRS_FILE"
    log_dim "Workdirs file removed"
else
    echo
    echo -e "${BOLD}Current workdirs:${RESET}"
    while IFS= read -r line; do
        echo -e "${GRAY}  $(basename "$line")${RESET}"
    done < "$WORKDIRS_FILE"
    
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
fi
