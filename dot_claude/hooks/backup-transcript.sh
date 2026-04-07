#!/bin/bash
# PreCompact hook: backup transcript before context compaction.
# Keeps up to 20 backups, deletes oldest when exceeded.

set -euo pipefail

BACKUP_DIR="$HOME/.claude/transcript-backups"
mkdir -p "$BACKUP_DIR"

# Read input to get transcript path if provided
INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

# Fallback: find the most recent .jsonl in projects dirs
if [ -z "$TRANSCRIPT" ] || [ ! -f "$TRANSCRIPT" ]; then
  TRANSCRIPT=$(find "$HOME/.claude/projects" -name '*.jsonl' -type f -newer "$BACKUP_DIR" 2>/dev/null | head -1)
fi

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  BASENAME=$(basename "$TRANSCRIPT")
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  cp "$TRANSCRIPT" "$BACKUP_DIR/${TIMESTAMP}-${BASENAME}"
fi

# Prune: keep only 20 most recent backups
BACKUP_COUNT=$(find "$BACKUP_DIR" -maxdepth 1 -type f | wc -l | tr -d ' ')
if [ "$BACKUP_COUNT" -gt 20 ]; then
  EXCESS=$((BACKUP_COUNT - 20))
  find "$BACKUP_DIR" -maxdepth 1 -type f -print0 | xargs -0 ls -1t | tail -"$EXCESS" | xargs rm -f
fi

exit 0
