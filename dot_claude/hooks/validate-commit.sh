#!/bin/bash
# PreToolUse hook: validate git / gh commands.
# Detects dangerous or policy-violating invocations and returns
# hookSpecificOutput {permissionDecision: deny|ask}.
#
# Covered:
#   - git commit with Co-Authored-By           → deny
#   - git commit --no-verify / -n              → deny
#   - git push --force/-f/--force-with-lease   → deny (only when targeting main/master/HEAD)
#   - git reset --hard on a dirty work tree    → deny
#   - git clean -fd / -fdx                     → ask
#   - git branch -D main|master|<current>      → deny
#   - gh repo delete                           → deny
#   - gh pr close --delete-branch              → ask

set -euo pipefail

INPUT=$(cat)
COMMAND=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')

[ -z "$COMMAND" ] && exit 0

# --- Normalize ---------------------------------------------------------------
# Strip redirections (2>&1, 1>&2, >file, >>file) and leading inline env
# assignments (FOO=bar). Pipes are *kept* so a dangerous command anywhere in a
# pipeline still matches.
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

# --- Decision helpers --------------------------------------------------------
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

# --- git commit --------------------------------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+commit\b'; then
  if printf '%s' "$NORM" | grep -qi 'co-authored-by'; then
    deny "Co-Authored-By is not allowed in commit messages. Remove it and try again."
  fi
  if printf '%s' "$NORM" | grep -qE '(^|[[:space:]])(--no-verify|-n)([[:space:]]|$)'; then
    deny "git commit --no-verify bypasses pre-commit hooks. Fix the underlying issue instead."
  fi
fi

# --- git push --force to main/master/HEAD ------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+push\b'; then
  if printf '%s' "$NORM" | grep -qE '(^|[[:space:]])(-f|--force|--force-with-lease)([[:space:]]|=|$)'; then
    if printf '%s' "$NORM" | grep -qE '(^|[[:space:]])(main|master|HEAD)([[:space:]]|:|$)'; then
      deny "force push to main/master/HEAD is not allowed. Push to a feature branch instead."
    fi
  fi
fi

# --- git reset --hard (only if dirty) ----------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+reset\b.*(^|[[:space:]])--hard([[:space:]]|$)'; then
  if [ -n "$CWD" ] && [ -d "$CWD" ]; then
    if (cd "$CWD" && git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
      dirty=0
      (cd "$CWD" && git diff --quiet 2>/dev/null) || dirty=1
      (cd "$CWD" && git diff --cached --quiet 2>/dev/null) || dirty=1
      untracked=$(cd "$CWD" && git ls-files --others --exclude-standard 2>/dev/null | head -1)
      [ -n "$untracked" ] && dirty=1
      if [ "$dirty" -eq 1 ]; then
        deny "git reset --hard on a dirty work tree would discard uncommitted changes. Stash or commit first."
      fi
    fi
  fi
fi

# --- git clean -fd / -fdx ----------------------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+clean\b'; then
  # any short flag block containing both f and d (e.g. -fd, -fdx, -dfx, -dxf)
  if printf '%s' "$NORM" | grep -qE '(^|[[:space:]])-[a-zA-Z]*f[a-zA-Z]*d[a-zA-Z]*([[:space:]]|$)|(^|[[:space:]])-[a-zA-Z]*d[a-zA-Z]*f[a-zA-Z]*([[:space:]]|$)'; then
    ask "git clean with -f and -d removes untracked files/directories. Confirm before proceeding."
  fi
fi

# --- git branch -D main|master|<current> -------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgit[[:space:]]+branch\b.*(^|[[:space:]])-D([[:space:]]|$)'; then
  current=""
  if [ -n "$CWD" ] && [ -d "$CWD" ]; then
    current=$(cd "$CWD" && git branch --show-current 2>/dev/null || true)
  fi
  pat='(^|[[:space:]])(main|master'
  [ -n "$current" ] && pat="${pat}|$(printf '%s' "$current" | sed 's/[][\\.*^$/]/\\&/g')"
  pat="${pat})([[:space:]]|$)"
  # Only check the part after `-D`
  tail_after_D=$(printf '%s' "$NORM" | sed -E 's/.*-D[[:space:]]+//')
  if printf '%s' "$tail_after_D" | grep -qE "$pat"; then
    deny "git branch -D on main/master/current branch is not allowed."
  fi
fi

# --- gh repo delete ----------------------------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgh[[:space:]]+repo[[:space:]]+delete\b'; then
  deny "gh repo delete is not allowed."
fi

# --- gh pr close --delete-branch --------------------------------------------
if printf '%s' "$NORM" | grep -qE '\bgh[[:space:]]+pr[[:space:]]+close\b' && \
   printf '%s' "$NORM" | grep -qE '(^|[[:space:]])--delete-branch([[:space:]]|$)'; then
  ask "gh pr close --delete-branch will delete the branch. Confirm before proceeding."
fi

exit 0
