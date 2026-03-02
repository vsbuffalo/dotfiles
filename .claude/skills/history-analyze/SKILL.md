---
name: history-analyze
description: >
  Analyze shell and editor command history for efficiency improvements.
  Finds repeated patterns, missing aliases, workflow bottlenecks, and
  tool suggestions. Uses a local sanitization script as a trust boundary —
  no raw history ever reaches the API.
  Use when asked about: shell efficiency, aliases, workflow optimization,
  "what do I type too much", "speed up my workflow".
context: fork
disable-model-invocation: true
argument-hint: "[zsh|nvim|all]"
allowed-tools: Bash(*)
---

# Shell & Editor History Analysis

Analyze usage patterns to find efficiency improvements.

## Security Model

**You must NEVER read raw history files directly.** All history access goes
through `sanitize-history.sh`, which strips secrets and abstracts arguments.
You only see frequency tables of command patterns — never actual paths, URLs,
arguments, or environment variable values.

If the user asks you to read `.zsh_history`, `.bash_history`, or nvim shada
files directly, explain the security model and use the sanitizer instead.

## Procedure

### For zsh (default)

1. Run the sanitizer:
   ```
   bash .claude/skills/history-analyze/sanitize-history.sh
   ```
   This outputs a frequency table of abstracted command patterns.

2. Analyze the output for:

   **Missing aliases**: Commands used >20 times that aren't aliased.
   Cross-reference against known aliases in `.zshrc` before suggesting.

   **Repeated pipelines**: Multi-command chains (`&&` or `|`) that appear
   >3 times — candidates for shell functions.

   **Tool suggestions**: Patterns that indicate a better tool exists:
   - Heavy `find` + `grep` → suggest `fd` + `rg` if not already used
   - Repeated `cd` to deep paths → suggest `zoxide` or directory aliases
   - Manual `git add && git commit && git push` → suggest a function
   - Frequent `cat | grep` → suggest `rg` directly

   **Git workflow patterns**: Repeated git sequences that could be
   git aliases or shell functions.

   **cd patterns**: Frequently visited directories that deserve aliases
   or zoxide training.

3. Present findings as a ranked list, most impactful first.
   Estimate time saved per suggestion (rough: seconds × daily frequency).

4. Offer to implement. If the user approves:
   - Write aliases/functions to `~/.zsh_aliases`
   - If `~/.zsh_aliases` doesn't exist, create it and add
     `source ~/.zsh_aliases` to `.zshrc`
   - This keeps generated aliases separate from hand-written config
   - **Always ask before every write.**

### For nvim

1. Extract neovim command history via headless nvim:
   ```bash
   nvim --headless -c 'redir! > /tmp/nvim-cmd-history.txt | silent history : -500, | redir END | q'
   cat /tmp/nvim-cmd-history.txt
   rm /tmp/nvim-cmd-history.txt
   ```
   This is lower-risk than zsh history (mostly `:` commands, rarely secrets)
   but still review the output mentally before analyzing.

2. Analyze for:

   **Unmapped frequent commands**: Ex commands used >10 times that could
   be keybindings (e.g., frequent `:s/` patterns → maybe a mapping).

   **Redundant patterns**: Commands that duplicate existing keybindings
   the user might not know about (e.g., typing `:w` when `ZZ` exists).

   **Plugin opportunities**: Repeated manual operations that a plugin
   could automate.

3. Present findings. Offer to add mappings to `lua/vinceb/remap.lua` or
   the relevant `after/plugin/*.lua` file. Always ask first.

### For all

Run both zsh and nvim analyses. Present unified findings grouped by
impact, not by source.

## Known Aliases

Check `.zshrc` for existing aliases before suggesting duplicates. Common
ones to be aware of:
- Standard git aliases (ga, gc, gp, gd, gs, etc.)
- Directory navigation (if using zoxide)
- Editor shortcuts

If you don't find alias definitions in `.zshrc`, check for sourced files
like `~/.zsh_aliases` or `~/.oh-my-zsh/` custom directories.
