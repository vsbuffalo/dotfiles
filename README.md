## Dotfiles

Dotfiles for macOS — zsh, neovim, tmux, git — maintained by
[**Dewey**](#dewey), a Claude Code agent that lives in the repo. It tracks
plugin health, keeps docs in sync with config, and runs parallel agent
workflows via tmux. No custom runtime — just `CLAUDE.md`, skills, and
project memory.

> **Warning**: If you use my `dotfiles`, you *must* modify this to your own
> purposes! `.gitconfig` contains my name/email — simply cloning and running
> setup will make your commits under *my* identity.

## Installation

```bash
bash setup.sh
```

If you have an existing `~/.config/`, it won't be overwritten — but none of the
dotfiles configs will be linked. Remove or merge your existing `.config/` after
running `setup.sh`.

For SSH key management via Apple Keychain:

```bash
ssh-add --apple-use-keychain ~/.ssh/[your-private-key]
```

## What's in here

| Path | What |
|------|------|
| `.zshrc`, `.zsh_plugins.txt` | Zsh config, antidote plugins |
| `.config/nvim/` | NeoVim ([docs](https://github.com/vsbuffalo/dotfiles/tree/main/.config/nvim)) |
| `.config/` | alacritty, starship, etc. |
| `.claude/` | Claude Code settings & skills: audit, history-analyze, commands, doc-sync ([docs](docs/claude-code.md)) |
| `.tmux.conf` | tmux config |
| `.gitconfig` | Git config |
| `.Rprofile`, `.R/`, `.condarc` | R and conda config |
| `bootloaders/` | Boot loader configs |
| `scripts/` | Automation scripts (see below) |
| `setup.sh` | Bootstrap installer |

## Scripts

### `scripts/sort-screenshots`

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

### `scripts/start-agents`

Launches parallel Claude Code agents in tmux. One agent per directory, or
use `--worktree` mode to spin up git worktrees from a single repo.

```bash
# Three agents as tiled panes (default)
start-agents --worktree ~/my-repo 3

# Or separate windows
start-agents --windows ~/project-a ~/project-b
```

See [docs/tmux.md](docs/tmux.md) for the full workflow.

**Setup**: macOS screenshots are redirected to `~/Pictures/Screenshots/`:

```bash
defaults write com.apple.screencapture location ~/Pictures/Screenshots
killall SystemUIServer
```

**Cron**: runs nightly at midnight to sort new screenshots into subfolders:

```
0 0 * * * /Users/vsb/dotfiles/scripts/sort-screenshots >> /tmp/sort-screenshots.log 2>&1
```

## Dewey the Dotfiles Librarian

Dewey is a Claude Code agent that maintains this repo. There's no custom
runtime — it's just Claude Code reading a `CLAUDE.md` file, discovering
skills in `.claude/skills/`, and using project memory for cross-session state.

```bash
dewey               # interactive session
dewey "question"    # one-shot answer
```

| Skill | What it does |
|-------|-------------|
| `/audit` | Tiered neovim plugin staleness checker (3/6/12-month cadence) |
| `/history-analyze [zsh\|nvim\|all]` | Analyze command history for missing aliases, repeated patterns, tool suggestions |
| `/commands [topic]` | Full keybinding & command reference (neovim, zsh, tmux, git, cargo, opam, uv) |
| `/doc-sync` | Diff config against docs and propose updates |
| `/notes [topic]` | Lab notebook for recording findings |

History analysis runs through a committed sanitizer script
(`.claude/skills/history-analyze/sanitize-history.sh`) — Claude never sees raw
history, only frequency tables with secrets stripped and arguments abstracted.

### Build your own

The whole thing is four pieces that any repo can replicate:

1. **`CLAUDE.md`** — persona, architecture map, and a compact command reference
   that's always in context. This is the only file Claude Code reads
   automatically. ([ours](CLAUDE.md))

2. **`.claude/skills/`** — slash commands loaded on demand. Each is a markdown
   prompt file. Skills keep expensive lookups (full command reference, audit
   logic, history analysis) out of the base context window.

3. **Project memory** — a directory Claude Code persists across sessions
   (`~/.claude/projects/.../memory/`). Dewey stores audit dates, discovered
   commands, and session notes here. No database, just markdown files.

4. **Shell alias** — a one-liner in `.zshrc` that pins Claude Code to the repo
   directory and adds a system prompt for the greeting.

The pattern scales: add a skill file, reference it from `CLAUDE.md`, done.
See [docs/dewey.md](docs/dewey.md) for the full technical breakdown.

## Docs

- [Shell aliases & functions](docs/aliases.md) — quick reference for everything in `.zshrc`
- [NeoVim config](.config/nvim/README.md) — plugins, LSP, keybindings, REPL, DAP
- [Cron jobs](docs/cron.md) — scheduled tasks, PATH gotchas, full crontab
- [Claude Code settings](docs/claude-code.md) — permissions, symlink strategy, per-project overrides
- [Tailscale setup](docs/tailscale.md) — mesh VPN and SSH between Macs
- [Ergonomic desk setup](docs/ergonomics.md) — sit-stand desk heights and monitor positioning
- [Tmux & agent workflow](docs/tmux.md) — session layout, keybindings, parallel agent launcher
- [Dewey internals](docs/dewey.md) — how the agent works, security model, memory

## Caveats

Only tested on macOS.
