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

check_status() {
  local name="$1"
  local url="$2"
  local expected="$3"
  local status
  status="$(curl -sS -m 5 -o /dev/null -w '%{http_code}' "$url" || true)"
  if [ "$status" = "$expected" ]; then
    printf "  OK   %s %s returned %s\n" "$name" "$url" "$status"
  else
    printf "  FAIL %s %s returned %s, expected %s\n" "$name" "$url" "${status:-no response}" "$expected"
  fi
}

check "Homepage" "http://localhost:31337"
check "Jellyfin" "http://localhost:8096"
check "FileBrowser" "http://localhost:8081"
check "Notes" "http://localhost:8090"
check_status "WebDAV" "http://localhost:8091" "401"
