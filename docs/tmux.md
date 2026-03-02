# Tmux Configuration

Tmux config lives in `.tmux.conf`. It supports both interactive human use and
parallel Claude Code agent sessions.

## Session Layout

By convention, three named sessions:

| Session | Purpose |
|---------|---------|
| `main` | Day-to-day interactive work |
| `agents` | Parallel Claude Code agents (created by `start-agents`) |
| `scratch` | Throwaway experiments |

Jump between them with `M-1`, `M-2`, `M-3` (requires terminal Meta key).

## Keybindings

Prefix is `C-b` (default).

### Windows & Navigation

| Key | Action |
|-----|--------|
| `C-b c` | New window |
| `C-b [0-9]` | Switch to window N |
| `C-b C-a` | Last window |
| `C-b ,` | Rename window |
| `C-b b` | Toggle status bar |

### Splits

| Key | Action |
|-----|--------|
| `C-b \|` | Split horizontal (keeps cwd) |
| `C-b -` | Split vertical (keeps cwd) |

### Copy Mode

| Key | Action |
|-----|--------|
| `C-b [` | Enter copy mode (vi keys) |

### Agent / Multi-Pane

| Key | Action |
|-----|--------|
| `C-b S` | Toggle sync panes (broadcast input) |
| `M-1` | Jump to `main` session |
| `M-2` | Jump to `agents` session |
| `M-3` | Jump to `scratch` session |

### Config

| Key | Action |
|-----|--------|
| `C-b r` | Reload config (shows confirmation) |

## Agent Workflow

### Quick Start

```bash
# Three agents on worktrees — tiled panes in one window (default)
start-agents --worktree ~/my-repo 3

# Same, but each agent in its own window
start-agents --windows --worktree ~/my-repo 3

# One agent per project directory
start-agents ~/project-a ~/project-b
```

Creates a tmux session named `agents`. Default layout is `--panes` (all agents
tiled in one window). Use `--windows` for one window per agent.

### Pane layout (default)

All agents share one window with a tiled layout. Workflow:

1. Glance at all agents in the overview
2. `C-b z` to zoom into one that needs attention
3. `C-b z` again to pop back to the tiled view
4. `C-b q N` to jump to pane N by number

### Window layout (`--windows`)

Each agent gets a full-screen window. Switch with `C-b N` or `C-b n`/`C-b p`.
Better when agents produce a lot of output and you need full-screen context.

### Worktree Mode

```bash
start-agents --worktree ~/repo 3
```

Creates git worktrees under `<repo>/.worktrees/` with branches named
`agent/YYYYMMDD-N`. Reuses existing worktrees from the same day.

### Monitoring Agents

- **Bell notification**: agents that finish or need attention trigger a bell.
  `monitor-bell on` + `bell-action any` means you see it from any session.
- **Activity monitor**: window names highlight on output (`monitor-activity on`).
- **Broadcast input**: `C-b S` toggles synchronized panes — type once, send to
  all panes in the current window.

### Cleanup

Worktrees can be cleaned up with:

```bash
cd ~/repo
git worktree list          # see what exists
git worktree remove .worktrees/YYYYMMDD-N
```

## Settings Reference

| Setting | Value | Rationale |
|---------|-------|-----------|
| `escape-time` | `0` | No delay for Esc (vi mode) |
| `history-limit` | `50000` | Agents produce verbose output |
| `base-index` | `1` | 1-based window numbering (closer to keyboard) |
| `renumber-windows` | `on` | No gaps after closing windows |
| `automatic-rename` | `off` | Agents keep their window labels |
| `allow-rename` | `off` | Prevents escape sequences from renaming |
| `mouse` | `on` | Click to select panes/windows, scroll |
| `mode-keys` | `vi` | Vi keys in copy mode |
| `monitor-bell` | `on` | Agent completion notifications |
| `bell-action` | `any` | Bell visible from any session |

## Plugins (TPM)

Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm).

### Setup

TPM is installed automatically by `setup.sh`. If you need to install manually:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

After loading the config, install plugins with `prefix + I`.

### Installed Plugins

- **[tmux-dotbar](https://github.com/vaaleyard/tmux-dotbar)** — minimal status
  bar theme with dot-separated window names, prefix highlight, and Nerd Font icons.

## Terminal Meta Key

`M-1`/`M-2`/`M-3` require your terminal to send Meta (not Esc-prefix):

- **iTerm2**: Preferences > Profiles > Keys > Left Option Key = `Esc+`
- **Alacritty**: set `option_as_alt: Both` in config
- **Kitty**: `macos_option_as_alt yes`

If Meta isn't configured, these bindings simply don't fire — no errors.
