# Claude Code Settings

Claude Code stores its config at `~/.claude/`, but that directory also accumulates
runtime data (history, cache, session state, etc.). We version-control only the
portable configuration by selectively symlinking from the dotfiles repo:

```
~/dotfiles/.claude/              ← source of truth (git-tracked)
  ├── settings.json               ← preferences: model, plugins
  ├── settings.local.json         ← permissions: allow/deny lists, hooks
  ├── agents/                     ← custom agent definitions
  ├── commands/                   ← slash commands (/commit, /memory-*, etc.)
  └── skills/                     ← custom skills

~/.claude/                        ← runtime directory
  ├── settings.json           → symlink to dotfiles
  ├── settings.local.json     → symlink to dotfiles
  ├── agents/                 → symlink to dotfiles
  ├── commands/               → symlink to dotfiles
  ├── skills/                 → symlink to dotfiles
  └── history.jsonl, cache/, projects/, ...  (local, not tracked)
```

`setup.sh` handles this via `link_into_dir`, which symlinks individual items
without clobbering the runtime data that Claude Code writes alongside them.

## Per-project overrides

Claude Code merges settings from multiple levels. Each project can have its own
`.claude/settings.local.json` for context-specific permissions:

- `.config/.claude/settings.local.json` — allows `git add`, `ln`, etc. for dotfile management
- `.config/nvim/.claude/settings.local.json` — allows nvim-related operations

## Permission philosophy

The global `settings.local.json` allowlists three categories:

1. **File tools** (`Edit`, `Read`, `Write`, `Glob`, `Grep`) — always allowed
2. **Safe bash** (git read ops, `ls`, `find`, `mkdir`, build tools like `cargo`/`dune`/`uv`/`npm`) — always allowed
3. **Git write ops** (`git add`, `git commit`, `git merge`, etc.) — allowed, but `git add -A` is blocked by both deny rule and a PreToolUse hook

**Still prompts** (by design): `git push`, `rm`, `curl`/`wget`, `brew install`, `sudo`, and anything else not explicitly allowlisted.

## Workflow for adding new permissions

When Claude prompts you for a command you want to always allow:
1. Select "Always allow" in the prompt, OR
2. Add the pattern to `~/dotfiles/.claude/settings.local.json` and commit

Use `Bash(command_prefix:*)` syntax for allow rules (`:*` matches any suffix).
Use `Bash(*pattern*)` glob syntax for deny rules.
