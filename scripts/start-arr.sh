#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Starting optional media automation services."
echo "Use these only with legal content sources and indexers you are allowed to access."
docker compose --profile arr up -d
