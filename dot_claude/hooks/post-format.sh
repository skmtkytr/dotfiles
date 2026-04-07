#!/bin/bash
# PostToolUse hook: auto-format files after Edit/Write/NotebookEdit
# Reads tool_input from stdin JSON, formats based on file extension.

set -euo pipefail

# Extract file_path from stdin JSON
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

format_with() {
  local cmd="$1"
  shift
  if command -v "$cmd" &>/dev/null; then
    "$cmd" "$@" &>/dev/null || true
  fi
}

case "$EXT" in
  lua)
    format_with stylua "$FILE_PATH"
    ;;
  js|jsx|ts|tsx|css|scss|md|json|yaml|yml|html|vue|svelte|graphql)
    format_with prettier --write "$FILE_PATH"
    ;;
  py)
    format_with ruff format "$FILE_PATH"
    ;;
  rs)
    format_with rustfmt "$FILE_PATH"
    ;;
  go)
    format_with gofmt -w "$FILE_PATH"
    ;;
  fish)
    format_with fish_indent -w "$FILE_PATH"
    ;;
  rb)
    format_with rubocop -a --fail-level fatal "$FILE_PATH"
    ;;
esac

exit 0
