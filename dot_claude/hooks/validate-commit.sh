#!/bin/bash
# PreToolUse hook: block git commits containing Co-Authored-By

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//;s/"$//')

# Only check git commit commands
case "$COMMAND" in
  *git\ commit*|*git\ commit*) ;;
  *) exit 0 ;;
esac

# Check for Co-Authored-By (case-insensitive)
if echo "$COMMAND" | grep -qi 'co-authored-by'; then
  cat <<'EOF'
{"decision":"block","reason":"Co-Authored-By is not allowed in commit messages. Remove it and try again."}
EOF
  exit 0
fi

exit 0
