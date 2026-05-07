#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

PROFILE_ARGS=(--profile core)

if docker compose ps --services --filter status=running | grep -Eq '^(jellyseerr|sonarr|radarr|prowlarr|bazarr|qbittorrent|flaresolverr)$'; then
  PROFILE_ARGS+=(--profile arr)
fi

if docker compose ps --services --filter status=running | grep -q '^cloudflared$'; then
  PROFILE_ARGS+=(--profile cloudflare)
fi

echo "Recommended: run ./scripts/backup.sh before updates."
read -r -p "Continue with image pull and recreate? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Update cancelled."
  exit 0
fi

docker compose "${PROFILE_ARGS[@]}" pull
docker compose "${PROFILE_ARGS[@]}" up -d

read -r -p "Prune unused Docker images? [y/N]: " prune
if [ "$prune" = "y" ] || [ "$prune" = "Y" ]; then
  docker image prune -f
fi

echo "Update complete."
./scripts/check.sh || true
