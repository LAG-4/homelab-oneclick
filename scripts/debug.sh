#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

SERVICE="${1:-}"

if [ -z "$SERVICE" ]; then
  echo "Usage: ./scripts/debug.sh <service>"
  echo
  echo "Known services:"
  docker compose config --services
  exit 1
fi

echo "Status for $SERVICE"
docker compose ps "$SERVICE" || true

echo
echo "Last 120 log lines for $SERVICE"
docker compose logs --tail=120 "$SERVICE"
