#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Install Docker Engine or Docker Desktop first:"
  echo "https://docs.docker.com/engine/install/"
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is not available. Install the Docker Compose plugin:"
  echo "https://docs.docker.com/compose/install/linux/"
  exit 1
fi

if [ ! -f .env ]; then
  cp .env.example .env
  echo "Created .env from .env.example"
fi

set -a
# shellcheck disable=SC1091
. ./.env
set +a

mkdir -p \
  "${CONFIG_DIR:-./config}/jellyfin" \
  "${CONFIG_DIR:-./config}/filebrowser" \
  "${CONFIG_DIR:-./config}/notes-filebrowser" \
  "${CONFIG_DIR:-./config}/jellyseerr" \
  "${CONFIG_DIR:-./config}/sonarr" \
  "${CONFIG_DIR:-./config}/radarr" \
  "${CONFIG_DIR:-./config}/prowlarr" \
  "${CONFIG_DIR:-./config}/qbittorrent" \
  "${CONFIG_DIR:-./config}/bazarr" \
  "${DATA_DIR:-./data}/jellyfin-cache" \
  "${DOWNLOADS_DIR:-./downloads}/torrents" \
  "${FILES_DIR:-./files}" \
  "${MEDIA_DIR:-./media-samples}/movies" \
  "${MEDIA_DIR:-./media-samples}/tv" \
  "${NOTES_DIR:-./notes}"

if [ ! -f "${FILES_DIR:-./files}/README.md" ]; then
  cat > "${FILES_DIR:-./files}/README.md" <<'NOTE'
# Files

This folder is served by FileBrowser. Put files here that you want available through the web UI.
NOTE
fi

if [ ! -f "${NOTES_DIR:-./notes}/Welcome.md" ]; then
  cat > "${NOTES_DIR:-./notes}/Welcome.md" <<'NOTE'
# Welcome

This folder is served by FileBrowser and WebDAV. Put an Obsidian vault here if you want private notes sync.
NOTE
fi

echo "Starting core homelab services..."
docker compose --profile core up -d

echo
echo "Done. Open these locally:"
echo "  Dashboard:   http://localhost:31337"
echo "  Jellyfin:    http://localhost:8096"
echo "  FileBrowser: http://localhost:8081"
echo "  Notes:       http://localhost:8090"
echo "  WebDAV:      http://localhost:8091"
echo
echo "Run ./scripts/check.sh to verify service health."
