# Scripts

Automation scripts in `scripts/`.

## `scripts/sort-screenshots`

Sorts macOS screenshots into `~/Pictures/Screenshots/YYYY/MM-Mon/` subfolders
by parsing the date from the filename. Handles both old (`Screen Shot ...`) and
new (`Screenshot ...`) naming formats, plus screen recordings.

```bash
# Preview what would happen
sort-screenshots --dry-run

# Sort screenshots already in ~/Pictures/Screenshots (default)
sort-screenshots

# Sort from a different source directory
sort-screenshots ~/Desktop
```

**Setup**: macOS screenshots are redirected to `~/Pictures/Screenshots/`:

```bash
defaults write com.apple.screencapture location ~/Pictures/Screenshots
killall SystemUIServer
```

**Cron**: runs nightly at midnight to sort new screenshots into subfolders:

```
0 0 * * * /Users/vsb/dotfiles/scripts/sort-screenshots >> /tmp/sort-screenshots.log 2>&1
```

## `scripts/start-agents`

Launches parallel Claude Code agents in tmux. One agent per directory, or
use `--worktree` mode to spin up git worktrees from a single repo.

```bash
# Three agents as tiled panes (default)
start-agents --worktree ~/my-repo 3

# Or separate windows
start-agents --windows ~/project-a ~/project-b
```

See [docs/tmux.md](tmux.md) for the full workflow.

## `scripts/tmux-sysinfo.sh`

Prints a compact CPU/RAM status line for the tmux status bar. Used by
`.tmux.conf` to display system load.

```
⚡ CPU 12% · RAM 68%/16G
```
