# Vendored Zsh Plugins

Zsh plugins vendored locally instead of fetched at runtime by a plugin
manager. `vendor/` is gitignored — reproduced via `make clone`, verified via
content checksums in `.audit-signatures`. Updates are reviewed by Claude Code
for supply chain attacks before merging.

## Why vendor?

Zsh plugins run arbitrary code on every shell start with full user
permissions. A compromised upstream push gets executed immediately. Vendoring
means: nothing runs that hasn't been audited first.

## Plugins

Defined in `plugins.txt`:

| Plugin | Purpose |
|--------|---------|
| [zsh-z](https://github.com/agkozak/zsh-z) | Frecency-based directory jumper |
| [pure](https://github.com/sindresorhus/pure) | Minimal async prompt |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Live command coloring |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Ghost text from history |
| [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | Up/down searches by substring |

## Workflow

```
First time:
  make clone ──→ make scan ──→ make sign
    │               │              │
    shallow          Claude         record audited
    clone all        reviews        content checksums
    plugins          ALL code

Updates:
  make update ──→ make audit ──→ make apply
    │                │              │
    fetch            Claude         merge + re-sign
    latest,          reviews        + clean diffs
    write diffs      diffs only

Verify anytime:
  make status     compare content checksums against signed values
  make diff       view pending diffs without AI
```

## Files

| Path | Purpose |
|------|---------|
| `plugins.txt` | Plugin list (one GitHub repo per line) |
| `vendor/` | Shallow clones — gitignored, reproduced via `make clone` |
| `.audit-signatures` | Content checksums after audit — committed |
| `.diffs/` | Staged update diffs — gitignored, temporary |
| `Makefile` | All workflow targets |

## Adding a plugin

1. Add `owner/repo` to `plugins.txt`
2. `make clone` to fetch it
3. `make scan` to audit full source
4. `make sign` to record the audited checksums
5. Commit `plugins.txt` and `.audit-signatures`
