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

SHOW_FULL_PATH=false

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --path)
            SHOW_FULL_PATH=true
            ;;
        --help|-h)
            echo "Usage: $0 [--path]"
            echo "List configured workdirs"
            echo ""
            echo "Options:"
            echo "  --path    Show full paths instead of directory names"
            echo "  --help    Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown argument: $arg"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

WORKDIRS_FILE="${DEV_DIR:-}/compose/workdirs.txt"

# Check if file exists or is empty
if [ ! -f "$WORKDIRS_FILE" ] || [ ! -s "$WORKDIRS_FILE" ]; then
    log_dim "No workdirs configured"
    exit 0
fi

# Count directories and check status
count=$(wc -l < "$WORKDIRS_FILE" | xargs)
valid_count=0
invalid_count=0

# First pass to count valid/invalid
while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    if [ -d "$dir" ]; then
        ((valid_count++))
    else
        ((invalid_count++))
    fi
done < "$WORKDIRS_FILE"

# Header with summary
if [ $invalid_count -eq 0 ]; then
    echo -e "${BOLD}Workdirs${RESET} ${GRAY}($count)${RESET}"
else
    echo -e "${BOLD}Workdirs${RESET} ${GRAY}($count)${RESET} ${YELLOW}⚠ $invalid_count missing${RESET}"
fi

# Display workdirs line-by-line
while IFS= read -r dir; do
    [[ -z "$dir" ]] && continue
    
    if [ -d "$dir" ]; then
        STATUS="${GREEN}✓${RESET}"
        NAME_COLOR="${RESET}"
    else
        STATUS="${RED}✗${RESET}"
        NAME_COLOR="${GRAY}"
    fi
    
    NAME=$([[ "$SHOW_FULL_PATH" == true ]] && echo "$dir" || basename "$dir")
    echo -e "  $STATUS ${NAME_COLOR}$NAME${RESET}"
done < "$WORKDIRS_FILE"

# Footer with helpful info
if [ $invalid_count -gt 0 ]; then
    echo
    log_warn "Some directories are missing or inaccessible"
    log_dim "Use the remove script to clean up missing paths"
fi
