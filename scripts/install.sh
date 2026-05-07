#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Homelab Oneclick installer"
echo

./scripts/bootstrap.sh
echo
./scripts/check.sh
echo
./scripts/urls.sh
