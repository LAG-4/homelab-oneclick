#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [ ! -f .env ]; then
  cp .env.example .env
fi

if ! grep -q '^CLOUDFLARE_TUNNEL_TOKEN=.' .env; then
  echo "Set CLOUDFLARE_TUNNEL_TOKEN in .env first."
  echo "Docs: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/"
  exit 1
fi

docker compose --profile cloudflare up -d cloudflared
