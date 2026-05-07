#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BACKUP="${1:-}"

if [ -z "$BACKUP" ]; then
  echo "Usage: ./scripts/restore.sh backups/homelab-oneclick-YYYYMMDD-HHMMSS.tar.gz"
  exit 1
fi

if [ ! -f "$BACKUP" ]; then
  echo "Backup file not found: $BACKUP"
  exit 1
fi

echo "This will extract $BACKUP into:"
echo "  $ROOT"
echo
read -r -p "Continue? [y/N]: " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
  echo "Restore cancelled."
  exit 0
fi

tar -xzf "$BACKUP" -C "$ROOT"
echo "Restore complete."
echo "Run ./scripts/bootstrap.sh to recreate folders and start services."
