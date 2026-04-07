function claude --wraps claude --description "Run claude with global Node (bypass project mise.toml)"
    set -l claude_bin (mise where npm:@anthropic-ai/claude-code 2>/dev/null)/bin/claude
    if not test -x "$claude_bin"
        # Fallback: use shim path directly
        set claude_bin $HOME/.local/share/mise/shims/claude
    end
    mise x node@25.6.1 -- $claude_bin $argv
end
