#!/bin/bash
# PreToolUse hook: gate rm commands.
#   - recursive rm against $HOME / chezmoi source / ~/.ghq / ~/.config / /  → deny
#   - any other rm                                                          → ask

set -euo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Normalize: strip redirects + leading inline env. Pipes kept.
normalize() {
  local c="$1"
  c=$(printf '%s' "$c" | sed -E '
    s/[12]?>&[12]//g
    s/[12]?>>?[[:space:]]*[^[:space:]|;&]+//g
    s/(^|[;&|])[[:space:]]*([A-Za-z_][A-Za-z0-9_]*=[^[:space:]]+[[:space:]]+)+/\1/g
  ')
  printf '%s' "$c"
}
NORM=$(normalize "$COMMAND")

# Not an rm invocation at all → allow
printf '%s' "$NORM" | grep -qE '(^|[[:space:]/;&|`$(])rm([[:space:]]|$)' || exit 0

deny() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}
ask() {
  jq -n --arg reason "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "ask",
      permissionDecisionReason: $reason
    }
  }'
  exit 0
}

# Recursive flag: any short flag block containing r or R (e.g. -r, -rf, -fr, -Rf, -fRv)
RECURSIVE_FLAG='(^|[[:space:]])-[a-zA-Z]*[rR][a-zA-Z]*([[:space:]]|$)'

if printf '%s' "$NORM" | grep -qE "$RECURSIVE_FLAG"; then
  # Build danger-path regex. We accept ~, $HOME, or the literal expansion.
  home_lit=$(printf '%s' "${HOME:-/home}" | sed 's/[][\\.*^$/]/\\&/g')
  # paths that, when removed recursively, would destroy chezmoi/dotfiles/ghq/config/HOME/root
  # match either the path itself or path/<anything>
  DANGER='(/|~|\$HOME|'"$home_lit"')(/(\.local/share/chezmoi|\.ghq|\.config)(/[^[:space:]]*)?)?([[:space:]]|;|&|\||$)'
  # Also match bare ~ / $HOME / /
  if printf '%s' "$NORM" | grep -qE "rm[[:space:]]+[^|;&]*${DANGER}"; then
    deny "rm -r against \$HOME / ~/.local/share/chezmoi / ~/.ghq / ~/.config / / is not allowed."
  fi
fi

# Any other rm → require confirmation
ask "rm コマンドの実行にはユーザー確認が必要です"
