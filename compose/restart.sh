#!/usr/bin/env bash
set -euo pipefail

cd $DEV_DIR

echo "Current directory: $(pwd)"
echo "Checking for running services..."

is_running=$(docker compose ps --services --filter "status=running" | grep -w "debian" || true)
    
if [ -z "$is_running" ]; then
    echo "Debian service is not running."
    docker compose up -d
    ovim start
else
    echo "Debian service is already running, restarting it..."
    docker compose down
    docker compose up -d
    ovim start
fi
