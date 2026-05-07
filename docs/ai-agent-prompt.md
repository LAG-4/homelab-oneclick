# AI Agent Setup Prompt

Copy this prompt into an AI coding agent that has terminal access to the machine where you want to install Homelab Oneclick.

Before running it, make sure you trust the agent and understand that it may install Docker, start services, and create local folders.

## Prompt

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

## Fully Automated Variant

Use this only on a fresh machine where you are comfortable with defaults.

```text
Install Homelab Oneclick from https://github.com/LAG-4/homelab-oneclick on this machine.

Use defaults, keep services LAN-only, do not expose anything publicly, and do not enable optional media automation unless I ask.

Check/install Docker, clone the repo, run ./scripts/doctor.sh, run ./scripts/bootstrap.sh, then run ./scripts/check.sh and print the URLs.

If Docker cannot be started or ports are already in use, stop and tell me the exact issue.
```
