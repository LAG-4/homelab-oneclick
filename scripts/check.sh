#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Docker Compose services:"
docker compose ps

echo
echo "HTTP checks:"
check() {
  local name="$1"
  local url="$2"
  if curl -fsS -m 5 "$url" >/dev/null; then
    printf "  OK   %s %s\n" "$name" "$url"
  else
    printf "  FAIL %s %s\n" "$name" "$url"
  fi
}

check "Homepage" "http://localhost:31337"
check "Jellyfin" "http://localhost:8096"
check "FileBrowser" "http://localhost:8081"
check "Notes" "http://localhost:8090"
check "WebDAV" "http://localhost:8091"
