#!/usr/bin/env bash
# sanitize-history.sh — Extract command patterns from zsh history
# without exposing sensitive arguments.
#
# TRUST BOUNDARY: This script is the only path through which shell
# history reaches Claude. It runs locally and emits only abstracted
# frequency tables. Raw history never enters API context.
#
# This file is security-critical. Review changes carefully.
# Claude should invoke this script but never modify it.
#
# Usage: ./sanitize-history.sh [history-file] [max-lines]
# Defaults: ~/.zsh_history, last 10000 lines

set -euo pipefail

HISTORY_FILE="${1:-$HOME/.zsh_history}"
MAX_LINES="${2:-10000}"

if [[ ! -f "$HISTORY_FILE" ]]; then
    echo "ERROR: History file not found: $HISTORY_FILE" >&2
    exit 1
fi

# --- Sensitive patterns to drop entirely ---
# These lines are removed before any analysis.
# Add patterns here if you find new secret formats in your history.
SENSITIVE_PATTERNS=(
    # Credentials and tokens
    '[Kk][Ee][Yy]='
    '[Tt][Oo][Kk][Ee][Nn]='
    '[Ss][Ee][Cc][Rr][Ee][Tt]='
    '[Pp][Aa][Ss][Ss][Ww][Oo][Rr][Dd]='
    'Authorization:'
    'Bearer '
    # Environment variable assignments (catches all, not just known ones)
    'export [A-Z_]*=.'
    # Auth and credential tools
    'ssh-keygen'
    'openssl.*-pass'
    'mysql.*-p'
    'psql.*password'
    'gh auth'
    'vault '
    '1password'
    'op '            # 1Password CLI
    'aws configure'
    # Known API key prefixes
    'AWS_ACCESS'
    'ANTHROPIC_API'
    'OPENAI_API'
    'GITHUB_TOKEN'
    'HF_TOKEN'
    # Connection strings
    'mongodb://'
    'postgres://'
    'mysql://'
    'redis://'
    # .env file access
    'cat.*\.env'
    'less.*\.env'
    'source.*\.env'
    '\. .*\.env'
)

GREP_ARGS=()
for pat in "${SENSITIVE_PATTERNS[@]}"; do
    GREP_ARGS+=(-e "$pat")
done

# --- Phase 1: Command frequency table ---
echo "# Command frequency (last $MAX_LINES commands, arguments abstracted)"
echo "# Generated: $(date -Iseconds)"
echo ""

tail -n "$MAX_LINES" "$HISTORY_FILE" \
    | sed 's/^: [0-9]*:[0-9]*;//' \
    | grep -iv "${GREP_ARGS[@]}" \
    | awk '{
        cmd = $1
        # Tools with meaningful subcommands — keep the subcommand
        if (cmd == "git" || cmd == "docker" || cmd == "kubectl" || \
            cmd == "brew" || cmd == "cargo" || cmd == "npm" || \
            cmd == "yarn" || cmd == "pnpm" || \
            cmd == "pip" || cmd == "uv" || cmd == "conda" || \
            cmd == "opam" || cmd == "dune" || cmd == "esy" || \
            cmd == "rustup" || cmd == "systemctl" || \
            cmd == "launchctl" || cmd == "tmux") {
            if (NF >= 2)
                pattern = cmd " " $2
            else
                pattern = cmd
        }
        # Path-taking commands — abstract the path
        else if (cmd == "cd" || cmd == "cat" || cmd == "vim" || \
                 cmd == "nvim" || cmd == "code" || cmd == "less" || \
                 cmd == "bat" || cmd == "head" || cmd == "tail" || \
                 cmd == "wc" || cmd == "file" || cmd == "stat" || \
                 cmd == "open" || cmd == "chmod" || cmd == "chown" || \
                 cmd == "source" || cmd == "." || \
                 cmd == "rg" || cmd == "fd" || cmd == "find") {
            pattern = cmd " <arg>"
        }
        # Network commands — abstract the target
        else if (cmd == "ssh" || cmd == "scp" || cmd == "rsync" || \
                 cmd == "ping" || cmd == "dig" || cmd == "nslookup") {
            pattern = cmd " <target>"
        }
        # HTTP commands — abstract the URL
        else if (cmd == "curl" || cmd == "wget" || cmd == "http" || \
                 cmd == "httpie") {
            pattern = cmd " <url>"
        }
        # Bare commands (no arguments)
        else if (NF == 1) {
            pattern = cmd
        }
        # Everything else — keep command, drop args
        else {
            pattern = cmd " ..."
        }
        counts[pattern]++
    }
    END {
        for (p in counts) printf "%6d\t%s\n", counts[p], p
    }' \
    | sort -rn \
    | head -80

echo ""
echo "---"
echo "# Repeated multi-command chains (alias/function candidates)"
echo "# Only command names shown — arguments stripped"
echo ""

tail -n "$MAX_LINES" "$HISTORY_FILE" \
    | sed 's/^: [0-9]*:[0-9]*;//' \
    | grep -iv "${GREP_ARGS[@]}" \
    | grep -E '&&|\|' \
    | sed -E '
        # Strip quoted strings
        s/"[^"]*"//g
        s/'"'"'[^'"'"']*'"'"'//g
        # Strip everything after each command name until next operator
        s/([a-zA-Z0-9_.-]+)[[:space:]]+[^|&]*/\1 /g
        # Clean up whitespace
        s/[[:space:]]+/ /g
        s/^ //
        s/ $//
    ' \
    | awk '{ counts[$0]++ } END { for (c in counts) if (counts[c] > 2) printf "%6d\t%s\n", counts[c], c }' \
    | sort -rn \
    | head -20
