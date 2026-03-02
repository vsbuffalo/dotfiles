# Cron Jobs

All cron jobs managed via `crontab -e`. To list current jobs: `crontab -l`.

## Active Jobs

| Schedule | Command | Purpose |
|----------|---------|---------|
| `0 0 * * *` | `sort-screenshots` | Sort new screenshots into `YYYY/MM-Mon/` folders |

## Notes

- Cron uses a minimal PATH (`/usr/bin:/bin`), so always use full paths to
  binaries (e.g. `/Users/vsb/.local/bin/uv` not just `uv`).
- Output not captured by redirects gets delivered as local mail (`/var/mail/vsb`),
  which triggers the "You have mail" message on shell startup. Redirect both
  stdout and stderr to a log file to avoid this.
- macOS also supports `launchd` (plist files in `~/Library/LaunchAgents/`), which
  handles sleep/wake rescheduling better, but cron is simpler for these jobs.

## Full crontab

```cron
0 0 * * * /Users/vsb/dotfiles/scripts/sort-screenshots >> /tmp/sort-screenshots.log 2>&1
```
