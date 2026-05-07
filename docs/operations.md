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
