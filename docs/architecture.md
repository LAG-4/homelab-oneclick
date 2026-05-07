# Architecture

Homelab Oneclick is intentionally small. It gives you a working private cloud baseline, then lets you add optional media automation and remote access when you are ready.

## Core Stack

```text
Phone / laptop / TV
        |
        | LAN or Tailscale
        v
  http://server:31337
        |
        v
    Homepage dashboard
        |
        +--> Jellyfin       media streaming
        +--> FileBrowser    browser-based file access
        +--> Notes UI       browser access to notes folder
        +--> WebDAV         sync endpoint for notes/files
```

## Optional Media Automation

```text
Jellyseerr request
        |
        +--> Radarr  -> movies
        +--> Sonarr  -> TV
                |
                +--> Prowlarr      indexer manager
                +--> qBittorrent   download client
                +--> Bazarr        subtitles
```

Use optional media automation only with legal content and sources you are allowed to access.

## Remote Access Model

```text
Private devices
    |
    +--> Tailscale private network
            |
            +--> admin services and dashboard

Public HTTPS
    |
    +--> Cloudflare Tunnel
            |
            +--> selected services only
```

Recommended split:

- Tailscale for admin/private services.
- Cloudflare Tunnel only for services you intentionally want reachable over HTTPS.

## Data Layout

Runtime data is separated from repo code:

```text
config/        app configuration and databases
data/          cache data
downloads/     optional download workspace
files/         FileBrowser-served files
media-samples/ starter media folder
notes/         notes and WebDAV folder
backups/       generated backups
```

The repo ignores these folders so users do not accidentally commit private data.
