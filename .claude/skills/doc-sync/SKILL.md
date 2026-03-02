---
name: doc-sync
description: >
  Check and update documentation after config changes. Compares current
  config state against docs and keybinding tables. Use after modifying
  neovim config, zshrc, tmux.conf, or other dotfiles. Also responds to:
  "are my docs up to date", "check docs", "update documentation".
context: fork
disable-model-invocation: true
allowed-tools: Bash(git diff:*), Bash(cat:*), Bash(grep:*), Bash(find:*), Bash(ls:*)
---

# Documentation Sync

Check docs against current config state and propose updates.

## Doc Manifest

Each row maps a document to the config files it tracks. When those config
files change, the document may need updating.

| Document | Tracks | What to check |
|----------|--------|---------------|
| `.config/nvim/README.md` | `lua/vinceb/lazy.lua`, `after/plugin/*.lua`, LSP config | Plugin list, keybinding tables, LSP server table |
| `.config/nvim/CLAUDE.md` | Same + directory structure | Architecture notes, modification guidelines |
| Root `README.md` | `docs/`, `setup.sh`, top-level structure | Docs index, setup instructions |
| Root `CLAUDE.md` | All keybinding sources, `.claude/skills/` | Tier-1 command reference, skills index |
| `docs/aliases.md` | `.zshrc` | Alias definitions and descriptions |
| `docs/claude-code.md` | `.claude/` directory | Skill descriptions, settings |

## Procedure

1. **Detect changes**: Run `git diff --name-only HEAD` (unstaged) and
   `git diff --name-only --staged` to find modified files. If no git
   changes, ask the user what they changed or check recent commits with
   `git log --oneline -10 --name-only`.

2. **Match against manifest**: For each changed file, find which documents
   track it using the table above.

3. **Check each affected document**, one at a time:
   - Read the document
   - Read the relevant config files
   - Compare: Are keybinding tables accurate? Is the plugin list current?
     Are paths and descriptions correct?
   - If the document references line counts, plugin counts, or other
     quantitative claims, verify them.

4. **Propose updates**: Show a diff for each document that needs changes.
   Present one document at a time — don't batch. Explain what changed
   and why.

5. **Wait for approval** before writing each update. Never batch-write
   multiple doc changes without per-file approval.

## Scope Limits

- Only check documents listed in the manifest. Don't go looking for other
  markdown files to update.
- Don't rewrite documents for style — only fix factual inaccuracies
  (wrong keybindings, missing plugins, outdated paths).
- If a document is substantially out of date (>10 corrections needed),
  note this and offer to do a full rewrite rather than patching.
- If you find a keybinding conflict (same key mapped in multiple places),
  report it but don't resolve it — that's the user's decision.
