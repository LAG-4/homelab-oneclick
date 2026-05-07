#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=scripts/lib.sh
. "$ROOT/scripts/lib.sh"

pass=0
fail=0
warn=0

ok() {
  printf "OK   %s\n" "$1"
  pass=$((pass + 1))
}

bad() {
  printf "FAIL %s\n" "$1"
  fail=$((fail + 1))
}

note() {
  printf "WARN %s\n" "$1"
  warn=$((warn + 1))
}

check_cmd() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1 is installed"
  else
    bad "$1 is not installed"
  fi
}

check_port() {
  local port="$1"
  local name="$2"
  if command -v ss >/dev/null 2>&1 && ss -ltn "( sport = :$port )" 2>/dev/null | grep -q ":$port"; then
    note "port $port for $name is already in use"
  elif command -v lsof >/dev/null 2>&1 && lsof -i ":$port" >/dev/null 2>&1; then
    note "port $port for $name is already in use"
  else
    ok "port $port for $name looks free"
  fi
}

echo "Homelab doctor"
echo

check_cmd docker
check_cmd curl
check_cmd tar

if docker compose version >/dev/null 2>&1; then
  ok "Docker Compose v2 is available"
else
  bad "Docker Compose v2 is not available"
fi

if docker info >/dev/null 2>&1; then
  ok "Docker daemon is reachable"
else
  bad "Docker daemon is not reachable"
fi

if [ -f .env ]; then
  ok ".env exists"
else
  note ".env does not exist yet; bootstrap will create it from .env.example"
fi

load_env

check_port 31337 "Homepage"
check_port 8096 "Jellyfin"
check_port 8081 "FileBrowser"
check_port 8090 "Notes FileBrowser"
check_port 8091 "WebDAV"

echo
echo "System resources:"
if command -v free >/dev/null 2>&1; then
  free -h | sed 's/^/  /'
else
  note "free command not available; skipping memory check"
fi

if command -v df >/dev/null 2>&1; then
  df -h . | sed 's/^/  /'
fi

echo
echo "Directory checks:"
for dir in "${CONFIG_DIR:-./config}" "${DATA_DIR:-./data}" "${DOWNLOADS_DIR:-./downloads}" "${FILES_DIR:-./files}" "${MEDIA_DIR:-./media-samples}" "${NOTES_DIR:-./notes}"; do
  if mkdir -p "$dir" 2>/dev/null && [ -w "$dir" ]; then
    ok "$dir is writable"
  else
    bad "$dir is not writable"
  fi
done

echo
echo "Compose validation:"
if docker compose --profile core config >/dev/null 2>&1; then
  ok "core profile validates"
else
  bad "core profile does not validate"
fi

if docker compose --profile arr config >/dev/null 2>&1; then
  ok "arr profile validates"
else
  bad "arr profile does not validate"
fi

echo
echo "Summary: ${pass} ok, ${warn} warnings, ${fail} failures"

if [ "$fail" -gt 0 ]; then
  exit 1
fi
