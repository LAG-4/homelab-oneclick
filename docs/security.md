# Security Checklist

## Before Exposing Anything

- Change default passwords.
- Use strong passwords for WebDAV, FileBrowser, and app admin accounts.
- Keep admin tools private behind Tailscale.
- Do not expose qBittorrent, Sonarr, Radarr, Prowlarr, or Docker socket publicly.
- Use Cloudflare Access or another auth layer for public dashboards.
- Keep `.env` out of git.

## Recommended Exposure Model

Private via Tailscale:

- Sonarr
- Radarr
- Prowlarr
- qBittorrent

Public via Cloudflare Tunnel if needed:

- Jellyfin
- Jellyseerr
- Homepage
- FileBrowser only if protected by strong auth and/or Cloudflare Access

## Updates

Update images regularly:

```bash
docker compose pull
docker compose --profile core up -d
```

Remove unused images:

```bash
docker image prune
```

## Backups

Back up:

- `.env`
- `config/`
- `notes/`
- any real media metadata you care about

Do not publish backups. They often contain API keys, auth cookies, app databases, and private paths.

## Secrets Scan

Before pushing a public repo:

```bash
git status --ignored
git diff --cached
```

Optional tools:

- Gitleaks: https://github.com/gitleaks/gitleaks
- TruffleHog: https://github.com/trufflesecurity/trufflehog
