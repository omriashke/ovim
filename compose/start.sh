#!/bin/bash
set -euo pipefail

# Check for --build flag
BUILD_FLAG=""
SESSION_NAME=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --build)
            BUILD_FLAG="--build"
            shift
            ;;
        *)
            # If it's not --build, treat it as session name
            SESSION_NAME="$1"
            shift
            ;;
    esac
done

cd "$DEV_DIR"

# Run docker compose with or without --build flag
if [ -n "$BUILD_FLAG" ]; then
    echo "Building and starting containers..."
    docker compose build
    docker compose up -d
else
    docker compose up -d
fi

echo "Executing into debian container..."

# Check if session name was provided as argument
if [ -z "$SESSION_NAME" ]; then
    # No session name provided - find the most recent session or use default
    echo "No session name provided, checking for existing sessions..."
    
    docker compose exec debian bash -c "
        # Get list of sessions, most recent first
        LATEST_SESSION=\$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2)
        
        if [ -n \"\$LATEST_SESSION\" ]; then
            echo 'Attaching to most recent session: '\$LATEST_SESSION
            tmux attach-session -t \"\$LATEST_SESSION\"
        else
            echo 'No existing sessions found, creating default session: develop'
            tmux new-session -s 'develop' 'bash'
        fi
    "
else
    # Session name provided as argument
    echo "Session: $SESSION_NAME"
    
    # Check if session exists and attach or create accordingly
    docker compose exec debian bash -c "
        if tmux has-session -t '$SESSION_NAME' 2>/dev/null; then
            echo 'Attaching to existing session: $SESSION_NAME'
            tmux attach-session -t '$SESSION_NAME'
        else
            echo 'Creating new session: $SESSION_NAME'
            tmux new-session -s '$SESSION_NAME' 'bash'
        fi
    "
fi
