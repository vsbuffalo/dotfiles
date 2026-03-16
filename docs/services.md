# Services

Persistent launchd services managed via our homebrewed `svc` CLI and monitored
by Gatus.

## Architecture

```
manifest.toml ──→ svc CLI (inspect/manage)
                   └── launchctl (start/stop/restart)

gatus.yaml ──→ Gatus (status page + uptime history)
               └── http://localhost:8080 (Tailnet-accessible)
               └── SQLite: ~/.local/share/gatus/data.db
```

Config lives in `.config/services/`, symlinked to `~/.config/services/` via
`linkdotfile .config` in `setup.sh`.

## `svc` CLI

Python script (`bin/svc`) using uv inline metadata, defopt for subcommands,
and rich for colored output. Symlinked to `~/.local/bin/svc` by `setup.sh`.

| Command | Description |
|---------|-------------|
| `svc ls` | List services from manifest (name, port, description) |
| `svc status` | Per-service: loaded? PID? health endpoint reachable? |
| `svc check` | Drift detection: plist missing, loaded but untracked, label mismatch |
| `svc start <name>` | `launchctl kickstart` the service |
| `svc stop <name>` | `launchctl kill SIGTERM` the service |
| `svc restart <name>` | `launchctl kickstart -k` (kill + restart) |
| `svc logs <name>` | `tail -f` stdout/stderr from plist log paths |
| `svc cat` | Pretty-print manifest with syntax highlighting |

## Gatus Status Page

Gatus runs as a LaunchAgent (`com.gatus.serve`) on port 8080, bound to
`0.0.0.0` for Tailnet access. It polls endpoints every 30-60s and stores
uptime history in SQLite.

Installed via `go install` (thuja only). Config: `.config/services/gatus.yaml`.

## Services

| Service | Label | Port | What it does |
|---------|-------|------|-------------|
| Ollama | `homebrew.mxcl.ollama` | 11434 | Local LLM inference server |
| Arcana | `com.arcana.serve` | 8787 | Obsidian vault MCP server |
| Gatus | `com.gatus.serve` | 8080 | Status page with uptime history |

Arcana is also exposed via Cloudflare tunnel at `arcana-mcp.vincebuffalo.com`.
Gatus monitors the tunnel endpoint in addition to the local service.

## Manifest

`manifest.toml` is the source of truth for what services should exist. Each
entry has a label, plist path, optional port, health URL, and description.

Notable fields:
- `healthy_below`: HTTP status threshold for health (arcana returns 401, which is alive)
- `tracked = false`: suppress `svc check` warnings when the service is intentionally stopped

## Files

| File | Purpose |
|------|---------|
| `bin/svc` | CLI script |
| `.config/services/manifest.toml` | Service registry |
| `.config/services/gatus.yaml` | Gatus config |
| `.config/services/com.gatus.serve.plist` | Gatus LaunchAgent |
