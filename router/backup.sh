#!/usr/bin/env bash
# router/backup.sh — pull and encrypt GL.iNet Flint2 config backups
#
# Only creates a new backup if the content has changed since the last one.
# Encrypted with age so backups are safe to sync/store anywhere.
#
# Prerequisites:
#   brew install age
#   age-keygen -o ~/.config/age/key.txt   # one-time; save the public key
#
# Usage:
#   ./backup.sh                           # interactive
#   ROUTER=root@10.0.0.1 ./backup.sh      # override host
set -euo pipefail

ROUTER="${ROUTER:-root@192.168.8.1}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/backups/router}"
AGE_RECIPIENT_FILE="${AGE_RECIPIENT_FILE:-$HOME/.config/age/recipient.txt}"

# --- preflight ---
if [[ ! -f "$AGE_RECIPIENT_FILE" ]]; then
  echo "error: age recipient file not found at $AGE_RECIPIENT_FILE" >&2
  echo "  echo 'age1...' > $AGE_RECIPIENT_FILE" >&2
  exit 1
fi
command -v age >/dev/null || { echo "error: age not installed (brew install age)" >&2; exit 1; }

mkdir -p "$BACKUP_DIR"
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# --- pull config from router ---
echo "Pulling sysupgrade backup..."
ssh "$ROUTER" "sysupgrade -b /tmp/backup.tar.gz && cat /tmp/backup.tar.gz && rm -f /tmp/backup.tar.gz" > "$WORK/sysupgrade.tar.gz"

echo "Pulling AdGuardHome config..."
ssh "$ROUTER" "cat /etc/AdGuardHome/config.yaml" > "$WORK/adguardhome-config.yaml"

echo "Pulling installed packages..."
ssh "$ROUTER" "opkg list-installed" > "$WORK/opkg-installed.txt"

echo "Pulling overlay filesystem..."
ssh "$ROUTER" "tar czf - /overlay 2>/dev/null" > "$WORK/overlay.tar.gz"

# --- bundle ---
tar czf "$WORK/bundle.tar.gz" -C "$WORK" \
  sysupgrade.tar.gz adguardhome-config.yaml opkg-installed.txt overlay.tar.gz

# --- dedup: hash the stable inputs (skip archives that embed timestamps) ---
# sysupgrade and overlay tarballs change every run due to embedded timestamps,
# so we hash the extracted sysupgrade file listing + the plaintext files.
HASH=$( { tar tzf "$WORK/sysupgrade.tar.gz" | sort
          tar tzf "$WORK/overlay.tar.gz" | sort
          cat "$WORK/adguardhome-config.yaml"
          cat "$WORK/opkg-installed.txt"
        } | shasum | cut -d' ' -f1)
HASH_FILE="$BACKUP_DIR/.last-hash"

if [[ -f "$HASH_FILE" ]] && [[ "$(cat "$HASH_FILE")" == "$HASH" ]]; then
  echo "No changes since last backup — skipping."
  exit 0
fi

# --- encrypt and store ---
DATE=$(date +%F-%H%M)
OUTFILE="$BACKUP_DIR/flint2-${DATE}.tar.gz.age"

age -R "$AGE_RECIPIENT_FILE" -o "$OUTFILE" "$WORK/bundle.tar.gz"
echo "$HASH" > "$HASH_FILE"

echo "Backup saved: $OUTFILE"
