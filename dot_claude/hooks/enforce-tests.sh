#!/bin/bash
# Stop hook: enforce tests pass before allowing Claude to stop.
# Outputs JSON {"decision":"block","reason":"..."} to block, or exits 0 to allow.

set -euo pipefail

INPUT=$(cat)

# Infinite loop prevention: if stop_hook_active is true, allow stop
STOP_ACTIVE=$(echo "$INPUT" | grep -o '"stop_hook_active"[[:space:]]*:[[:space:]]*true' || true)
if [ -n "$STOP_ACTIVE" ]; then
  exit 0
fi

# Check if there are uncommitted code changes
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  exit 0
fi

CODE_PATTERN='\.(ts|tsx|js|jsx|py|rb|rs|go|lua|fish|sh)$'
CHANGED_CODE=$(git diff --name-only 2>/dev/null | grep -E "$CODE_PATTERN" || true)
STAGED_CODE=$(git diff --cached --name-only 2>/dev/null | grep -E "$CODE_PATTERN" || true)

if [ -z "$CHANGED_CODE" ] && [ -z "$STAGED_CODE" ]; then
  exit 0
fi

# Detect test runner and run tests
TEST_CMD=""
if [ -f "bun.lockb" ] || [ -f "bun.lock" ]; then
  command -v bun &>/dev/null && TEST_CMD="bun test"
elif [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
  TEST_CMD="npm test"
fi

if [ -z "$TEST_CMD" ] && [ -f "Makefile" ] && grep -qE '^test:' Makefile 2>/dev/null; then
  TEST_CMD="make test"
fi

if [ -z "$TEST_CMD" ] && [ -f "Cargo.toml" ]; then
  command -v cargo &>/dev/null && TEST_CMD="cargo test"
fi

if [ -z "$TEST_CMD" ] && [ -f "go.mod" ]; then
  command -v go &>/dev/null && TEST_CMD="go test ./..."
fi

if [ -z "$TEST_CMD" ] && [ -f "Gemfile" ]; then
  command -v bundle &>/dev/null && TEST_CMD="bundle exec rspec"
fi

if [ -z "$TEST_CMD" ] && [ -f "pyproject.toml" ]; then
  command -v pytest &>/dev/null && TEST_CMD="pytest"
fi

# No test runner found — allow stop
if [ -z "$TEST_CMD" ]; then
  exit 0
fi

# Run tests
if eval "$TEST_CMD" &>/dev/null; then
  exit 0
else
  echo "{\"decision\":\"block\",\"reason\":\"Tests failed ($TEST_CMD). Fix failing tests before stopping.\"}"
  exit 0
fi
