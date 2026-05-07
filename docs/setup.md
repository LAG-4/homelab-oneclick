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
docker info
```

`docker info` must succeed. If it cannot connect to `/var/run/docker.sock`, Docker is installed but the daemon is not running or your user cannot access it.

On Linux, add your user to the `docker` group if you do not want to use `sudo`:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in after running that.

Start Docker on Linux systems that use systemd:

```bash
sudo systemctl enable --now docker
```

On Docker Desktop, open the app and wait until Docker is running before starting the stack.

## 2. Clone And Boot

```bash
git clone https://github.com/LAG-4/homelab-oneclick.git
cd homelab-oneclick
./scripts/setup.sh
```

For a default setup without prompts:

```bash
./scripts/bootstrap.sh
```

The setup wizard writes `.env`, creates required folders, and can start the `core` Docker Compose profile. The bootstrap script creates `.env` from `.env.example` if needed and starts with defaults.

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
4. Decide whether you want private remote access with Tailscale or public HTTPS with Cloudflare Tunnel.

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
mkdir -p /mnt/storage/media/movies /mnt/storage/media/tv /mnt/storage/downloads /mnt/storage/files /mnt/storage/notes
```

## 6. Run Doctor

Before debugging manually, run:

```bash
./scripts/doctor.sh
```

It checks Docker, Compose, port conflicts, disk, memory, folder permissions, and Compose validity.

## 7. Update

```bash
./scripts/update.sh
```

If you use optional services:

```bash
docker compose --profile core --profile arr up -d
```
