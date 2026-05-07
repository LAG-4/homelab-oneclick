# Remote Access

You do not need to expose ports on your router to use this stack remotely.

Recommended approach:

- Use Tailscale for private access to admin tools.
- Use Cloudflare Tunnel only for services you intentionally want on public HTTPS.

## Option A: Tailscale

Tailscale creates a private encrypted network between your devices.

Docs:

- https://tailscale.com/
- https://tailscale.com/kb/1017/install
- https://tailscale.com/kb/1080/cli

Install and login:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Find your server's Tailscale IP:

```bash
tailscale ip -4
```

Then open from another Tailscale device:

```text
http://TAILSCALE_IP:31337
```

## Option B: Cloudflare Tunnel

Cloudflare Tunnel exposes selected local services over HTTPS without opening router ports.

Docs:

- https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/
- https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-remote-tunnel/
- https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/local-management/ingress/

Basic flow:

1. Buy/use a domain in Cloudflare.
2. Go to Cloudflare Zero Trust.
3. Create a tunnel.
4. Copy the Docker tunnel token.
5. Paste it into `.env`:

```env
CLOUDFLARE_TUNNEL_TOKEN=your-token
```

6. Start the tunnel:

```bash
./scripts/start-cloudflare.sh
```

7. In Cloudflare, add public hostnames pointing to internal service URLs:

```text
home.example.com     -> http://homepage:3000
media.example.com    -> http://jellyfin:8096
files.example.com    -> http://filebrowser:80
requests.example.com -> http://jellyseerr:5055
```

## What Not To Expose Publicly

Keep these private unless you know exactly what you are doing:

- qBittorrent
- Sonarr
- Radarr
- Prowlarr
- Docker socket

Use Tailscale for these.
