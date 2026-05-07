#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=scripts/lib.sh
. "$ROOT/scripts/lib.sh"

check_docker_ready

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
