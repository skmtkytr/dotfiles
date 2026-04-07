#!/bin/bash
# Start a headless nvim server inside the devcontainer with socat port forwarding.
# Run from the host: bash .devcontainer/nvim-server.sh [port]
#
# Connect: nvim --server localhost:6666 --remote-ui
# Stop:    bash .devcontainer/nvim-server.sh stop
set -euo pipefail

PORT="${1:-6666}"
CID=$(docker ps -q --filter "label=devcontainer.local_folder=$(pwd)")

if [ -z "$CID" ]; then
  echo "No devcontainer found for $(pwd)"
  exit 1
fi

if [ "$PORT" = "stop" ]; then
  docker exec "$CID" pkill -f "nvim --headless" 2>/dev/null || true
  pkill -f "socat.*docker exec.*$CID" 2>/dev/null || true
  echo "nvim server stopped"
  exit 0
fi

# Kill existing server and proxy
docker exec "$CID" pkill -f "nvim --headless" 2>/dev/null || true
pkill -f "socat.*docker exec.*$CID" 2>/dev/null || true
sleep 1

# Start nvim inside the container
docker exec -d -u vscode -e NVIM_HEADLESS_SERVER=1 "$CID" \
  sh -c "export PATH=\"\$HOME/.local/share/mise/shims:\$HOME/.local/bin:\$PATH\"; nvim --headless --listen 0.0.0.0:6666"
sleep 2

if ! docker exec "$CID" pgrep -f "nvim --headless" >/dev/null 2>&1; then
  echo "nvim server failed to start"
  exit 1
fi

# Start socat proxy on host
socat TCP-LISTEN:"$PORT",fork,reuseaddr SYSTEM:"docker exec -i $CID socat STDIO TCP:127.0.0.1:6666" &
sleep 1

if lsof -i :"$PORT" >/dev/null 2>&1; then
  echo "nvim server started (host:$PORT → container:6666)"
  echo "Connect: nvim --server localhost:$PORT --remote-ui"
else
  echo "socat proxy failed to start (is socat installed?)"
  exit 1
fi
