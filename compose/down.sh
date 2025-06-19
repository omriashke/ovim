#!/bin/bash
set -euo pipefail

cd $DEV_DIR

echo "Current directory: $(pwd)"
echo "Checking for running services..."

is_running=$(docker compose ps --services --filter "status=running" | grep -w "debian" || true)
    
if [ -z "$is_running" ]; then
    echo "Debian service is not running."
else
    echo "Debian service is already running, starting it..."
    docker compose down
fi

COMPOSE_FILE="$DEV_DIR/compose.yaml"
if [ -f "$COMPOSE_FILE" ]; then
    rm "$COMPOSE_FILE"
    echo "Removed compose file: $COMPOSE_FILE"
fi

WORKDIRS_FILE="$DEV_DIR/compose/workdirs.txt"
if [ -f "$WORKDIRS_FILE" ]; then
    rm "$WORKDIRS_FILE"
    echo "Removed compose file: $WORKDIRS_FILE"
fi
