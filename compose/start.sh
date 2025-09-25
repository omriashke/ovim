#!/usr/bin/env bash
set -euo pipefail

# --- Config -------------------------------------------------------------------
# Defaults (override via flags or env)
IMAGE_REPO="${IMAGE_REPO:-omriashkenazi/ovim}"
IMAGE_TAG="${IMAGE_TAG:-1.1.0}"
SERVICE_NAME="${SERVICE_NAME:-debian}"
COMPOSE_FILE="${COMPOSE_FILE:-compose.yaml}"

# Requires DEV_DIR in env
: "${DEV_DIR:?DEV_DIR must be set (path to your project root)}"

# --- Flags --------------------------------------------------------------------
BUILD_MODE="prebuilt"   # "prebuilt" (default) or "build"
DO_PULL="false"
SESSION_NAME=""
CUSTOM_TAG=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [--build] [--pull] [--tag <tag>] [session-name]

Modes:
  (default)    Use prebuilt image "${IMAGE_REPO}:${IMAGE_TAG}" and start containers.
  --build      Build locally with docker compose, then start containers.
  --pull       In prebuilt mode, pull the image before starting.
  --tag <tag>  Override image tag (e.g. --tag 1.2.3 or --tag latest).

Examples:
  $(basename "$0")                    # prebuilt, no pull
  $(basename "$0") --pull             # prebuilt, pull latest tag first
  $(basename "$0") --tag latest       # prebuilt, use :latest
  $(basename "$0") --build            # build locally
  $(basename "$0") my-session         # prebuilt, then tmux attach/create 'my-session'
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage; exit 0;;
    --build)
      BUILD_MODE="build"; shift;;
    --pull)
      DO_PULL="true"; shift;;
    --tag)
      CUSTOM_TAG="${2:-}"; shift 2;;
    *)
      # Everything else is interpreted as the tmux session name
      SESSION_NAME="$1"; shift;;
  esac
done

if [[ -n "${CUSTOM_TAG}" ]]; then
  IMAGE_TAG="${CUSTOM_TAG}"
fi

IMAGE="${IMAGE_REPO}:${IMAGE_TAG}"

# --- Ensure project files exist ----------------------------------------------
cd "$DEV_DIR"

# Create a local .env scaffold if missing (used by your dev repo itself)
if [[ ! -f ".env" ]]; then
  cat > .env << 'EOF'
# Ovim Environment Configuration
# Add your API keys and configurations here
# ⚠️ WARNING: This file may contain secrets. Add to .gitignore if needed.
# API_KEY=your_api_key_here
# DATABASE_URL=your_database_url
# NODE_VERSION=18
# PYTHON_VERSION=3.11
# ANTHROPIC_API_KEY=your-claude-api-key
# OPENAI_API_KEY=your-openai-api-key
EOF
  echo "Created .env file in $DEV_DIR"
fi

# Compose file bootstrap (if you rely on a template)
if [[ ! -f "${COMPOSE_FILE}" ]]; then
  if [[ -f "./compose/compose.template.yaml" ]]; then
    cp "./compose/compose.template.yaml" "${COMPOSE_FILE}"
  fi
fi

# --- Start containers ---------------------------------------------------------
if [[ "${BUILD_MODE}" == "build" ]]; then
  echo "Mode: local build (compose build && up -d)"

  # Track old image to clean up only if the tag is vimdev-debian:latest (legacy path)
  OLD_IMAGE_ID="$(docker images vimdev-debian:latest -q || true)"

  docker compose -f "${COMPOSE_FILE}" build --pull
  docker compose -f "${COMPOSE_FILE}" up -d

  if [[ -n "${OLD_IMAGE_ID}" ]]; then
    CURRENT_IMAGE_ID="$(docker images vimdev-debian:latest -q || true)"
    if [[ -n "${CURRENT_IMAGE_ID}" && "${OLD_IMAGE_ID}" != "${CURRENT_IMAGE_ID}" ]]; then
      echo "Removing old vimdev-debian image: ${OLD_IMAGE_ID}"
      docker rmi "${OLD_IMAGE_ID}" 2>/dev/null || echo "Old image already removed or in use"
    fi
  fi

else
  echo "Mode: prebuilt image (${IMAGE})"

  # If requested (or image missing), pull the prebuilt image.
  if [[ "${DO_PULL}" == "true" ]]; then
    echo "Pulling image: ${IMAGE}"
    docker pull "${IMAGE}"
  else
    if ! docker image inspect "${IMAGE}" >/dev/null 2>&1; then
      echo "Image ${IMAGE} not found locally; pulling..."
      docker pull "${IMAGE}"
    fi
  fi

  # IMPORTANT: because your compose file contains both 'build:' and 'image:',
  # we must ensure compose does NOT build in prebuilt mode:
  docker compose -f "${COMPOSE_FILE}" up -d --no-build

  # Optionally ensure the running service matches the requested tag
  echo "Ensured ${SERVICE_NAME} is up using ${IMAGE}"
fi

echo "Executing into ${SERVICE_NAME} container..."

# --- tmux session handling ----------------------------------------------------
if [[ -z "${SESSION_NAME}" ]]; then
  echo "No session name provided, checking for existing sessions..."
  docker compose exec "${SERVICE_NAME}" bash -c "
    LATEST_SESSION=\$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2)
    if [[ -n \"\$LATEST_SESSION\" ]]; then
      echo 'Attaching to most recent session: '\"\$LATEST_SESSION\"
      tmux attach-session -t \"\$LATEST_SESSION\"
    else
      echo 'No existing sessions found, creating default session: develop'
      tmux new-session -s 'develop' 'bash'
    fi
  "
else
  echo "Session: ${SESSION_NAME}"
  docker compose exec "${SERVICE_NAME}" bash -c "
    if tmux has-session -t '${SESSION_NAME}' 2>/dev/null; then
      echo 'Attaching to existing session: ${SESSION_NAME}'
      tmux attach-session -t '${SESSION_NAME}'
    else
      echo 'Creating new session: ${SESSION_NAME}'
      tmux new-session -s '${SESSION_NAME}' 'bash'
    fi
  "
fi
