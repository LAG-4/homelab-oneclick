# Troubleshooting

## Check Everything

```bash
./scripts/doctor.sh
./scripts/check.sh
```

Use `doctor.sh` before starting services. Use `check.sh` after services are running.

## See Running Containers

```bash
docker compose ps
```

## Docker Daemon Is Not Running

Error:

```text
failed to connect to the docker API at unix:///var/run/docker.sock
```

This means Docker is installed, but the daemon is not running or your user cannot access it.

Linux with systemd:

```bash
sudo systemctl enable --now docker
docker info
```

Docker Desktop:

1. Open Docker Desktop.
2. Wait until it says Docker is running.
3. Run `docker info`.

WSL2:

1. Start Docker Desktop on Windows.
2. Enable WSL integration for your distro in Docker Desktop settings.
3. Restart the terminal and run `docker info`.

If you recently added yourself to the Docker group:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in before trying again.

If you cannot log out yet, run the installer once inside the new group:

```bash
sg docker -c './scripts/install.sh'
```

## Read Logs

```bash
./scripts/debug.sh jellyfin
docker compose logs -f homepage
```

## Port Already In Use

Find the process:

```bash
sudo lsof -i :8096
```

Fix by changing the host port in `docker-compose.yml`, for example:

```yaml
ports:
  - "${BIND_IP:-0.0.0.0}:8097:8096"
```

The right side is the container port. The left side is the host port.

## Permission Problems

Check your user/group IDs:

```bash
id
```

Set `.env`:

```env
PUID=1000
PGID=1000
```

Then restart:

```bash
docker compose --profile core up -d
```

If a mounted folder is owned by root:

```bash
sudo chown -R "$USER":"$USER" config data notes media-samples downloads
```

## Docker Cannot Access `/var/run/docker.sock`

Homepage uses Docker socket read-only to show container info. On Linux, your Docker socket permissions may differ.

Options:

- Keep the socket mount and run Docker normally.
- Remove this line from the Homepage service if you do not want container status:

```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```

## Reset One Service

This deletes that service's config. Use carefully.

```bash
docker compose stop jellyfin
rm -rf config/jellyfin data/jellyfin-cache
./scripts/bootstrap.sh
```

## Reset Everything

This deletes generated configs and data.

```bash
./scripts/uninstall.sh --full
./scripts/bootstrap.sh
```
