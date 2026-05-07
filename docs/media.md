# Media Stack

## Jellyfin

Jellyfin is the core media server. It scans your media folder and streams to phones, TVs, browsers, and desktop clients.

Docs:

- https://jellyfin.org/
- https://jellyfin.org/docs/
- https://jellyfin.org/downloads/clients/

Default URL:

```text
http://localhost:8096
```

Default media folder inside the container:

```text
/media
```

Recommended host layout:

```text
media/
├── movies/
│   └── Movie Name (2024)/Movie Name (2024).mkv
└── tv/
    └── Show Name/Season 01/Show Name - S01E01.mkv
```

## Optional Automation Profile

Start optional tools:

```bash
./scripts/start-arr.sh
```

Services:

- Jellyseerr: request portal for Jellyfin
- Sonarr: TV library manager
- Radarr: movie library manager
- Prowlarr: indexer manager
- Bazarr: subtitle manager
- qBittorrent: download client
- FlareSolverr: optional challenge solver for supported workflows

Important: these tools are neutral automation tools. You are responsible for using them legally and with content/sources you are allowed to access.

Docs:

- Jellyseerr: https://docs.jellyseerr.dev/
- Sonarr: https://wiki.servarr.com/sonarr
- Radarr: https://wiki.servarr.com/radarr
- Prowlarr: https://wiki.servarr.com/prowlarr
- Bazarr: https://wiki.bazarr.media/
- qBittorrent: https://github.com/qbittorrent/qBittorrent/wiki
- FlareSolverr: https://github.com/FlareSolverr/FlareSolverr

## Basic Connection Flow

1. Create Jellyfin admin user.
2. Add `/media/movies` and `/media/tv` libraries in Jellyfin.
3. Open Jellyseerr and connect it to Jellyfin.
4. Open Sonarr/Radarr and set root folders:
   - Sonarr: `/tv`
   - Radarr: `/movies`
5. Add qBittorrent as download client in Sonarr/Radarr:
   - Host: `qbittorrent`
   - Port: `8080`
6. Add Prowlarr apps for Sonarr/Radarr if you use legal indexers.

## Troubleshooting

Jellyfin cannot see files:

- Check `.env` `MEDIA_DIR`.
- Check permissions for the host folder.
- Run `docker compose exec jellyfin ls -la /media`.

Sonarr/Radarr import fails:

- Make sure both tools and qBittorrent see the same download path as `/downloads`.
- Check the container logs:

```bash
./scripts/debug.sh sonarr
./scripts/debug.sh radarr
```
