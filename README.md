# Homelab Oneclick

A practical starter kit for turning an old laptop, mini PC, desktop, or VPS into a private cloud.

The goal is simple: clone the repo, run one command, and get a working baseline with media streaming, file access, notes sync, and a clean dashboard. You can then add remote access with Tailscale or Cloudflare Tunnel.

## What You Get

Core stack:

| Service | URL | Purpose |
| --- | --- | --- |
| Homepage | http://localhost:31337 | Personal dashboard |
| Jellyfin | http://localhost:8096 | Media streaming for legally owned media |
| FileBrowser | http://localhost:8081 | Browser-based file manager |
| Notes FileBrowser | http://localhost:8090 | Notes/vault browser |
| WebDAV | http://localhost:8091 | Notes/file sync endpoint |

Optional media automation profile:

| Service | URL | Purpose |
| --- | --- | --- |
| Jellyseerr | http://localhost:5055 | Request portal for Jellyfin |
| Sonarr | http://localhost:8989 | TV library management |
| Radarr | http://localhost:7878 | Movie library management |
| Prowlarr | http://localhost:9696 | Indexer management |
| Bazarr | http://localhost:6767 | Subtitle management |
| qBittorrent | http://localhost:8080 | Download client |
| FlareSolverr | http://localhost:8191 | Optional challenge solver for supported workflows |

Use the optional media automation tools only with legal content and sources you are allowed to access.

## Requirements

- Linux, macOS, Windows with WSL2, or a VPS
- Docker Engine or Docker Desktop
- Docker Compose v2
- 2 GB RAM minimum, 4 GB+ recommended
- Enough disk space for your media/files

Install Docker:

- Docker Engine: https://docs.docker.com/engine/install/
- Docker Desktop: https://docs.docker.com/desktop/
- Docker Compose: https://docs.docker.com/compose/

## AI Agent Setup

If you use AI coding agents like Claude Code, Codex, OpenCode, or similar terminal agents, you can paste this prompt and let the agent set this up for you.

<details>
<summary>Copy-paste AI agent setup prompt</summary>

```text
You are helping me install Homelab Oneclick on this machine.

Goal:
Set up https://github.com/LAG-4/homelab-oneclick so I get a working local homelab baseline with Homepage, Jellyfin, FileBrowser, Notes FileBrowser, and WebDAV.

Rules:
- Do not expose services publicly unless I explicitly ask.
- Do not add my personal tokens, domains, notes, or media to git.
- Do not overwrite existing folders without asking.
- If Docker is missing, install it using the official Docker docs for this OS.
- If Docker is installed but the daemon is not running, start it or tell me the exact command/app action needed.
- If ports are already in use, show me the conflict and ask whether to change ports or stop the existing service.
- Use Tailscale for private access recommendations and Cloudflare Tunnel only if I explicitly ask for public HTTPS.
- Use the optional Arr/media automation profile only if I explicitly ask for it.

Steps:
1. Detect the OS and package manager.
2. Check:
   - docker --version
   - docker compose version
   - docker info
3. If Docker/Compose is missing, install Docker Engine or Docker Desktop using official instructions:
   - Docker Engine: https://docs.docker.com/engine/install/
   - Docker Desktop: https://docs.docker.com/desktop/
   - Compose: https://docs.docker.com/compose/
4. Clone the repo if it is not already present:
   git clone https://github.com/LAG-4/homelab-oneclick.git
5. cd into homelab-oneclick.
6. Run:
   ./scripts/doctor.sh
7. If doctor reports failures, fix them before continuing.
8. Run:
   ./scripts/setup.sh
   Use sensible defaults unless I provide specific paths.
9. After setup, run:
   ./scripts/check.sh
10. Print the local and LAN URLs for:
   - Homepage
   - Jellyfin
   - FileBrowser
   - Notes
   - WebDAV
11. Explain what was installed and where the data lives.
12. Tell me how to stop, update, back up, restore, and uninstall:
   - ./scripts/stop.sh
   - ./scripts/update.sh
   - ./scripts/backup.sh
   - ./scripts/restore.sh <backup-file>
   - ./scripts/uninstall.sh
   - ./scripts/uninstall.sh --full

Do the work step by step. Show commands before running anything destructive. Stop and ask before deleting data, changing firewall rules, or exposing anything to the internet.
```

</details>

The longer prompt and a fully automated variant live in [docs/ai-agent-prompt.md](docs/ai-agent-prompt.md).

## Quick Start

Recommended first run:

```bash
git clone https://github.com/LAG-4/homelab-oneclick.git
cd homelab-oneclick
./scripts/setup.sh
```

Fast path with defaults:

```bash
git clone https://github.com/LAG-4/homelab-oneclick.git
cd homelab-oneclick
./scripts/bootstrap.sh
```

If you downloaded the folder manually:

```bash
cp .env.example .env
./scripts/bootstrap.sh
```

Then open:

```text
http://localhost:31337
```

On another device on the same network, replace `localhost` with the server IP:

```bash
hostname -I
```

## First Things To Change

Edit `.env`:

```env
TZ=Asia/Kolkata
WEBDAV_USER=your-user
WEBDAV_PASS=change-this
BIND_IP=0.0.0.0
```

Use `BIND_IP=127.0.0.1` if you plan to expose services only through a reverse proxy or Cloudflare Tunnel.

## Common Commands

```bash
# Interactive setup wizard
./scripts/setup.sh

# Check Docker, ports, disk, permissions, and compose validity
./scripts/doctor.sh

# Start the core stack
./scripts/bootstrap.sh

# Check service health
./scripts/check.sh

# Show logs for one service
./scripts/debug.sh jellyfin

# Back up config, env, homepage, and notes
./scripts/backup.sh

# Restore a backup
./scripts/restore.sh backups/homelab-oneclick-YYYYMMDD-HHMMSS.tar.gz

# Pull newer images and recreate services
./scripts/update.sh

# Stop and remove project containers/networks
./scripts/uninstall.sh

# Completely wipe generated repo-local data and recreate placeholders
./scripts/uninstall.sh --full

# Start optional media automation tools
./scripts/start-arr.sh

# Stop everything
./scripts/stop.sh
```

Manual Docker Compose equivalents:

```bash
docker compose --profile core up -d
docker compose --profile arr up -d
docker compose ps
docker compose logs -f jellyfin
```

## Remote Access Options

Start private first. Tailscale is the easiest and safest path for personal access.

- Tailscale guide: [docs/remote-access.md](docs/remote-access.md)
- Cloudflare Tunnel guide: [docs/remote-access.md](docs/remote-access.md)

Suggested split:

- Tailscale: private admin services like Sonarr, Radarr, Prowlarr, and qBittorrent
- Cloudflare Tunnel: public-friendly services like Jellyfin, Jellyseerr, FileBrowser, Homepage

## Setup Guides

- [Full setup guide](docs/setup.md)
- [Architecture](docs/architecture.md)
- [Operations guide](docs/operations.md)
- [AI agent setup prompt](docs/ai-agent-prompt.md)
- [Media stack guide](docs/media.md)
- [Files, notes, and WebDAV](docs/files-and-notes.md)
- [Remote access guide](docs/remote-access.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Security checklist](docs/security.md)
- [Project credits](docs/credits.md)

## Folder Layout

```text
homelab-oneclick/
├── docker-compose.yml
├── .env.example
├── cloudflare/               # Example Cloudflare Tunnel config
├── homepage/                 # Homepage dashboard config
├── scripts/                  # Bootstrap/check/debug helpers
├── docs/                     # Setup and debugging docs
├── config/                   # Generated app configs, ignored by git
├── data/                     # Generated cache data, ignored by git
├── downloads/                # Optional downloads folder, ignored by git
├── files/                    # FileBrowser-served files, ignored by git
├── media-samples/            # Starter media mount
├── notes/                    # Starter notes/WebDAV mount
└── backups/                  # Generated backups, ignored by git
```

## Security Notes

This repo intentionally does not include:

- API keys
- domains
- Cloudflare tunnel tokens
- Tailscale keys
- app databases
- private media
- personal notes
- live service configs

Before making your fork public, run:

```bash
git status --ignored
```

Make sure `.env`, `config/`, `data/`, `downloads/`, and real `media/` folders are not committed.

## License

MIT for the starter files in this repo. Each included service is owned by its upstream project and follows its own license.
