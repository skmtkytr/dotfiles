#!/bin/bash
# PostCompact hook: re-inject CLAUDE.md into context after compaction.
# stdout is injected into Claude's context.

set -euo pipefail

echo "=== Re-injected after compaction ==="

# Global CLAUDE.md
GLOBAL="$HOME/.config/claude/CLAUDE.md"
if [ -f "$GLOBAL" ]; then
  echo ""
  echo "## Global CLAUDE.md"
  echo ""
  cat "$GLOBAL"
fi

# Project CLAUDE.md (look in cwd and parents)
DIR="$(pwd)"
while [ "$DIR" != "/" ]; do
  PROJECT="$DIR/.claude/CLAUDE.md"
  if [ -f "$PROJECT" ]; then
    echo ""
    echo "## Project CLAUDE.md ($DIR)"
    echo ""
    cat "$PROJECT"
    break
  fi
  DIR="$(dirname "$DIR")"
done

exit 0
