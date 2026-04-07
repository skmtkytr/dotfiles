#!/bin/bash
# PreToolUse hook: require user confirmation for rm commands

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Check if command contains rm
if echo "$COMMAND" | grep -qE '\brm\b'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: "rm コマンドの実行にはユーザー確認が必要です"
    }
  }'
  exit 0
fi

exit 0
