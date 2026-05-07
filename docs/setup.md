# Full Setup Guide

## 1. Install Docker

Install Docker for your OS:

- Linux: https://docs.docker.com/engine/install/
- macOS/Windows: https://docs.docker.com/desktop/
- Compose plugin: https://docs.docker.com/compose/install/

Check that it works:

```bash
docker --version
docker compose version
```

On Linux, add your user to the `docker` group if you do not want to use `sudo`:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in after running that.

## 2. Clone And Boot

```bash
git clone https://github.com/LAG-4/homelab-oneclick.git
cd homelab-oneclick
./scripts/bootstrap.sh
```

The script creates `.env`, makes required folders, and starts the `core` Docker Compose profile.

## 3. Open The Dashboard

Local machine:

```text
http://localhost:31337
```

From another device on the same network:

```bash
hostname -I
```

Then open:

```text
http://SERVER_IP:31337
```

## 4. Configure Services

Recommended order:

1. Open Homepage at `http://localhost:31337`
2. Open Jellyfin at `http://localhost:8096` and create the first admin user.
3. Open FileBrowser at `http://localhost:8081` and change the default login.
4. Open Grafana at `http://localhost:3000`, login as `admin`, password from `.env`.
5. Decide whether you want private remote access with Tailscale or public HTTPS with Cloudflare Tunnel.

## 5. Add Real Storage

The default repo uses relative folders so it works anywhere. For a real server, point `.env` at larger disks:

```env
MEDIA_DIR=/mnt/storage/media
DOWNLOADS_DIR=/mnt/storage/downloads
FILES_DIR=/mnt/storage/files
NOTES_DIR=/mnt/storage/notes
CONFIG_DIR=/opt/homelab/config
DATA_DIR=/opt/homelab/data
```

Create folders before starting:

```bash
mkdir -p /mnt/storage/media/movies /mnt/storage/media/tv /mnt/storage/downloads /mnt/storage/notes
```

## 6. Update

```bash
docker compose pull
docker compose --profile core up -d
```

If you use optional services:

```bash
docker compose --profile core --profile arr up -d
```
