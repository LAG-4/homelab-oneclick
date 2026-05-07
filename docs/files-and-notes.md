# Files, Notes, And WebDAV

This starter includes two simple file services:

- FileBrowser for browsing/managing files in a web UI
- rclone WebDAV for syncing a folder with apps that support WebDAV

Docs:

- FileBrowser: https://filebrowser.org/
- rclone serve webdav: https://rclone.org/commands/rclone_serve_webdav/
- Obsidian: https://obsidian.md/

## URLs

```text
FileBrowser: http://localhost:8081
Notes UI:    http://localhost:8090
WebDAV:      http://localhost:8091
```

## Notes Folder

By default, notes live in:

```text
./notes
```

Change it in `.env`:

```env
NOTES_DIR=/path/to/your/obsidian-vault
```

## WebDAV Credentials

Set in `.env`:

```env
WEBDAV_USER=your-user
WEBDAV_PASS=your-password
```

Restart WebDAV:

```bash
docker compose --profile core up -d webdav
```

## Syncing With Obsidian

Options:

- Use a community WebDAV sync plugin if it fits your device setup.
- Use Syncthing if you prefer device-to-device sync.
- Use Obsidian Sync if you want the official paid route.

This repo only provides the WebDAV endpoint. Pick the sync method that matches your threat model and devices.
