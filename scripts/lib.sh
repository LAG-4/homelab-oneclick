#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

load_env() {
  cd "$ROOT"
  if [ -f .env ]; then
    set -a
    # shellcheck disable=SC1091
    . ./.env
    set +a
  fi
}

host_ip() {
  if command -v hostname >/dev/null 2>&1; then
    hostname -I 2>/dev/null | awk '{print $1}' && return
  fi

  if command -v ip >/dev/null 2>&1; then
    ip route get 1.1.1.1 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i=="src") {print $(i+1); exit}}' && return
  fi

  echo "localhost"
}

print_urls() {
  local ip
  ip="$(host_ip)"

  echo "Local URLs:"
  echo "  Dashboard:   http://localhost:31337"
  echo "  Jellyfin:    http://localhost:8096"
  echo "  FileBrowser: http://localhost:8081"
  echo "  Notes:       http://localhost:8090"
  echo "  WebDAV:      http://localhost:8091"
  echo
  echo "LAN URLs:"
  echo "  Dashboard:   http://${ip}:31337"
  echo "  Jellyfin:    http://${ip}:8096"
  echo "  FileBrowser: http://${ip}:8081"
  echo "  Notes:       http://${ip}:8090"
  echo "  WebDAV:      http://${ip}:8091"
}

ensure_env() {
  cd "$ROOT"
  if [ ! -f .env ]; then
    cp .env.example .env
    echo "Created .env from .env.example"
  fi
}

check_docker_ready() {
  if ! command -v docker >/dev/null 2>&1; then
    echo "Docker is not installed. Install Docker Engine or Docker Desktop first:"
    echo "https://docs.docker.com/engine/install/"
    return 1
  fi

  if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose v2 is not available. Install the Docker Compose plugin:"
    echo "https://docs.docker.com/compose/install/linux/"
    return 1
  fi

  if ! docker info >/dev/null 2>&1; then
    echo "Docker is installed, but the Docker daemon is not reachable."
    echo
    echo "Common fixes:"
    echo "  Linux/systemd:  sudo systemctl enable --now docker"
    echo "  Docker Desktop: start/open Docker Desktop and wait until it says it is running"
    echo "  WSL2:           start Docker Desktop on Windows and enable WSL integration"
    echo
    echo "If you recently ran 'sudo usermod -aG docker \"$USER\"', log out and back in."
    echo "Then test with: docker info"
    return 1
  fi
}

create_dirs() {
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
}
