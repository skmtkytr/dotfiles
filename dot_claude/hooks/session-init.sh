#!/bin/bash
# SessionStart hook: output git info and project context for Claude.
# stdout is injected into Claude's context.

set -euo pipefail

echo "=== Dev Context ==="

# --- Git info ---
if git rev-parse --is-inside-work-tree &>/dev/null; then
  BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
  echo ""
  echo "## Git"
  echo "Branch: $BRANCH"
  echo ""
  echo "Recent commits:"
  git log --oneline -5 2>/dev/null || true
  echo ""

  CHANGED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  echo "Uncommitted: ${CHANGED} changed, ${STAGED} staged, ${UNTRACKED} untracked"
fi

# --- Project detection ---
echo ""
echo "## Project"

if [ -f "package.json" ]; then
  NAME=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' package.json | head -1 | sed 's/.*"name"[[:space:]]*:[[:space:]]*"//;s/"$//')
  echo "Node.js: ${NAME:-unknown}"

  # Package manager detection
  if [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then
    echo "Package manager: bun"
  elif [ -f "pnpm-lock.yaml" ]; then
    echo "Package manager: pnpm"
  elif [ -f "yarn.lock" ]; then
    echo "Package manager: yarn"
  else
    echo "Package manager: npm"
  fi

  # Show available scripts
  SCRIPTS=$(grep -o '"[^"]*"[[:space:]]*:' package.json | sed -n '/"scripts"/,/}/p' 2>/dev/null || true)
  if command -v jq &>/dev/null && [ -f "package.json" ]; then
    SCRIPT_KEYS=$(jq -r '.scripts // {} | keys[]' package.json 2>/dev/null | head -10 | tr '\n' ', ' | sed 's/,$//')
    [ -n "$SCRIPT_KEYS" ] && echo "Scripts: $SCRIPT_KEYS"
  fi
fi

if [ -f "Makefile" ]; then
  echo "Makefile targets: $(grep -E '^[a-zA-Z_-]+:' Makefile 2>/dev/null | head -10 | sed 's/:.*//' | tr '\n' ', ' | sed 's/,$//')"
fi

if [ -f "Cargo.toml" ]; then
  NAME=$(grep -m1 '^name' Cargo.toml | sed 's/.*=//;s/[" ]//g')
  echo "Rust: ${NAME:-unknown}"
fi

if [ -f "go.mod" ]; then
  MODULE=$(head -1 go.mod | awk '{print $2}')
  echo "Go: ${MODULE:-unknown}"
fi

if [ -f "Gemfile" ]; then
  echo "Ruby: Gemfile detected"
fi

if [ -f "pyproject.toml" ]; then
  NAME=$(grep -m1 '^name' pyproject.toml | sed 's/.*=//;s/[" ]//g')
  echo "Python: ${NAME:-unknown}"
fi

exit 0
