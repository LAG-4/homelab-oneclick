# Operations

This page covers day-two tasks: checking health, updating containers, backing up, and restoring.

## Doctor

Run:

```bash
./scripts/doctor.sh
```

It checks:

- Docker and Compose availability
- Docker daemon access
- common port conflicts
- disk and memory summary
- folder permissions
- Compose profile validity

Run this before opening an issue or debugging a failed setup.

## Health Check

Run:

```bash
./scripts/check.sh
```

This checks the HTTP endpoints for the core services after they are started.

WebDAV returns `401` when it is healthy because authentication is required. The check script treats that as OK.

## URLs

Run:

```bash
./scripts/urls.sh
```

This prints local URLs and a best-effort LAN IP using `ip route` first, with portable fallbacks.

## Backup

Run:

```bash
./scripts/backup.sh
```

Backups are written to:

```text
backups/
```

Included by default:

- `.env`
- `homepage/`
- `config/`
- `notes/`

Excluded by default:

- media
- downloads
- cache data

This keeps backups small and avoids accidentally archiving large media libraries.

## Restore

Run:

```bash
./scripts/restore.sh backups/homelab-oneclick-YYYYMMDD-HHMMSS.tar.gz
./scripts/bootstrap.sh
```

Restore extracts the archive into the repo folder. Review what you are restoring before running it on a live server.

## Uninstall

Stop and remove only the Homelab Oneclick containers/networks:

```bash
./scripts/uninstall.sh
```

Completely wipe generated repo-local data so you can test a fresh setup again:

```bash
./scripts/uninstall.sh --full
```

This removes:

- `.env`
- `config/`
- `data/`
- `downloads/`
- `files/`
- `notes/`
- `backups/`

It does not uninstall Docker and does not delete the git repo itself.

Also remove locally referenced Docker images:

```bash
./scripts/uninstall.sh --full --images
```

## Update

Run:

```bash
./scripts/update.sh
```

The script:

1. Reminds you to back up.
2. Pulls newer Docker images.
3. Recreates running services.
4. Optionally prunes unused Docker images.
5. Runs the health check.

Manual equivalent:

```bash
docker compose pull
docker compose --profile core up -d
```

If you use optional media automation:

```bash
docker compose --profile core --profile arr up -d
```
