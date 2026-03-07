# Dewey: The Dotfiles Librarian

## What It Is

Dewey is a Claude Code agent persona defined by the files in this repo.
There's no custom runtime — it's just Claude Code reading the `CLAUDE.md`
at repo root, discovering skills in `.claude/skills/`, and using project
memory for cross-session state.

Launch it: `dewey` (alias for `claude --cwd ~/dotfiles`)

## Skills

| Command | What | Sensitive? |
|---------|------|-----------|
| `/audit` | Plugin staleness checker (tiered schedule) | Reads GitHub via web search |
| `/supply-chain-audit [path]` | Review vendored deps for supply chain attacks | Reads vendor source/diffs |
| `/commands [topic]` | Full keybinding/command reference | No |
| `/history-analyze [zsh\|nvim\|all]` | Shell efficiency analysis | Yes — uses sanitizer trust boundary |
| `/doc-sync` | Config-to-docs drift detection | No |
| `/notes [topic]` | Lab notebook for findings | No |

## Security: History Analysis

`/history-analyze` never reads raw `.zsh_history`. All access goes through
`.claude/skills/history-analyze/sanitize-history.sh`, a committed script that:

1. Drops lines matching sensitive patterns (tokens, keys, env vars, auth)
2. Abstracts arguments (paths → `<path>`, URLs → `<url>`)
3. Emits a frequency table of command patterns

The skill runs in a forked subagent (`context: fork`) so even the sanitized
data doesn't persist in the main conversation. The script is security-critical
and should be reviewed before any changes.

## Two-Tier Command Reference

- **Tier 1**: Compact table in root `CLAUDE.md`, always loaded (~30 lines)
- **Tier 2**: Full reference in `/commands` skill, loaded on demand

This means quick questions ("how do I run the nearest test?") are answered
from always-available context, while deep lookups ("show me all telescope
bindings with their source files") load the full reference.

## Memory

Project memory lives at `~/.claude/projects/.../memory/` (outside the repo):
- `neovim-audit.md` — Last audit dates and findings
- `command-notes.md` — Session discoveries and TILs

These are created by the skills on first use.

## Adding This to Your Shell

```bash
dewey() {
  local greet="On your first response, briefly introduce yourself as Dewey the dotfiles librarian and list your available slash commands. Keep it to 2-3 lines."
  (cd ~/dotfiles && claude --append-system-prompt "$greet" "${*:-hi}")
}
```

`dewey` → interactive session. `dewey "question"` → one-shot answer.
The greeting prompt is injected via `--append-system-prompt` so Dewey introduces itself on first response.
