#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=scripts/lib.sh
. "$ROOT/scripts/lib.sh"

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

ensure_env
load_env
create_dirs

echo "Starting core homelab services..."
docker compose --profile core up -d

echo
echo "Done."
print_urls
echo
echo "Run ./scripts/check.sh to verify service health."
