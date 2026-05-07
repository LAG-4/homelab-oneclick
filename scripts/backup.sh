#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=scripts/lib.sh
. "$ROOT/scripts/lib.sh"
load_env

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${BACKUP_DIR:-./backups}"
OUT_FILE="${OUT_DIR}/homelab-oneclick-${STAMP}.tar.gz"

mkdir -p "$OUT_DIR"

INCLUDES=()
[ -f .env ] && INCLUDES+=(".env")
[ -d homepage ] && INCLUDES+=("homepage")
[ -d "${CONFIG_DIR:-./config}" ] && INCLUDES+=("${CONFIG_DIR:-./config}")
[ -d "${NOTES_DIR:-./notes}" ] && INCLUDES+=("${NOTES_DIR:-./notes}")

if [ "${#INCLUDES[@]}" -eq 0 ]; then
  echo "Nothing to back up."
  exit 1
fi

echo "Creating backup: $OUT_FILE"
echo "Included:"
printf "  %s\n" "${INCLUDES[@]}"
echo
echo "Excluded by default: media, downloads, cache data."

tar \
  --exclude='*.db-wal' \
  --exclude='*.db-shm' \
  -czf "$OUT_FILE" \
  "${INCLUDES[@]}"

echo "Backup created: $OUT_FILE"
