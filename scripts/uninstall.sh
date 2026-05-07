#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck source=scripts/lib.sh
. "$ROOT/scripts/lib.sh"
load_env

FULL_WIPE=false
REMOVE_IMAGES=false
YES=false

for arg in "$@"; do
  case "$arg" in
    --full)
      FULL_WIPE=true
      ;;
    --images)
      REMOVE_IMAGES=true
      ;;
    --yes)
      YES=true
      ;;
    -h|--help)
      cat <<'HELP'
Usage:
  ./scripts/uninstall.sh
  ./scripts/uninstall.sh --full
  ./scripts/uninstall.sh --full --images

Default:
  Stops and removes Homelab Oneclick containers/networks only.

--full:
  Also deletes generated local files:
  .env, config/, data/, downloads/, files/, notes/, backups/

--images:
  Also removes Docker images referenced by this compose file.

--yes:
  Skip confirmation prompts. Use carefully.
HELP
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

echo "Homelab Oneclick uninstall"
echo
echo "This affects only this Compose project from:"
echo "  $ROOT"
echo

if [ "$YES" != true ]; then
  echo "This will stop and remove project containers/networks."
  read -r -p "Continue? [y/N]: " confirm
  if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Uninstall cancelled."
    exit 0
  fi
fi

docker compose --profile core --profile arr --profile cloudflare down --remove-orphans

if [ "$REMOVE_IMAGES" = true ]; then
  docker compose --profile core --profile arr --profile cloudflare down --remove-orphans --rmi local || true
fi

if [ "$FULL_WIPE" = true ]; then
  echo
  echo "Full wipe requested."
  echo "This deletes generated repo-local data:"
  echo "  .env"
  echo "  ${CONFIG_DIR:-./config}"
  echo "  ${DATA_DIR:-./data}"
  echo "  ${DOWNLOADS_DIR:-./downloads}"
  echo "  ${FILES_DIR:-./files}"
  echo "  ${NOTES_DIR:-./notes}"
  echo "  ${BACKUP_DIR:-./backups}"
  echo
  echo "It does not uninstall Docker and does not delete this git repo."

  if [ "$YES" != true ]; then
    read -r -p "Type WIPE HOMELAB to delete generated data: " phrase
    if [ "$phrase" != "WIPE HOMELAB" ]; then
      echo "Phrase did not match. Containers were removed, data was kept."
      exit 0
    fi
  fi

  rm -rf \
    .env \
    "${CONFIG_DIR:-./config}" \
    "${DATA_DIR:-./data}" \
    "${DOWNLOADS_DIR:-./downloads}" \
    "${FILES_DIR:-./files}" \
    "${NOTES_DIR:-./notes}" \
    "${BACKUP_DIR:-./backups}"

  mkdir -p config data downloads files notes
  touch config/.gitkeep data/.gitkeep downloads/.gitkeep files/.gitkeep notes/.gitkeep

  echo "Generated data removed."
fi

echo "Uninstall complete."
