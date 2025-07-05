#!/usr/bin/env bash
set -euo pipefail

# Get the directory from which the script was called
CALL_DIR="$(pwd)"
CALL_BASENAME="$(basename "$CALL_DIR")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load paths from workdirs.txt
mapfile -t paths < "$SCRIPT_DIR/../workdirs.txt"

# Find match by basename
MATCHED_PATH=""
for path in "${paths[@]}"; do
  if [[ "$(basename "$path")" == "$CALL_BASENAME" ]]; then
    MATCHED_PATH="$path"
    break
  fi
done

# Exit if no match
if [[ -z "$MATCHED_PATH" ]]; then
  echo "No matching path found for '$CALL_BASENAME'"
  exit 1
fi

# Find a valid Docker Compose file
COMPOSE_FILE=""
for candidate in "$CALL_DIR"/*.yml "$CALL_DIR"/*.yaml; do
  [[ ! -e "$candidate" ]] && continue

  filename="$(basename "$candidate")"
  if [[ "$filename" =~ compose\.ya?ml$ || "$filename" == docker-compose.* ]]; then
    COMPOSE_FILE="$filename"
    break
  fi
done

# Exit if no compose file
if [[ -z "$COMPOSE_FILE" ]]; then
  echo "No Docker Compose file found in $CALL_DIR"
  exit 1
fi

# Run Docker Compose
echo "Running: docker compose -f ./$COMPOSE_FILE --project-directory $MATCHED_PATH up"
docker compose -f "./$COMPOSE_FILE" --project-directory "$MATCHED_PATH" up
