function open --description "Open URL/file (xdg-open on Linux, native on Mac, TCP bridge in container)"
    if not test -f /.dockerenv
        if test (uname -s) = Linux
            xdg-open $argv
        else
            command open $argv
        end
        return
    end

    # In container: send to host open-bridge on TCP:12346
    if not command -q socat
        echo "open: socat not found" >&2
        return 1
    end

    set -l target $argv[1]
    if test -z "$target"
        echo "Usage: open <url|path>" >&2
        return 1
    end

    # If it looks like a URL, send as-is
    if string match -qr '^https?://' -- "$target"
        printf '%s' "$target" | socat - TCP:127.0.0.1:12346 2>/dev/null
    else
        # Resolve to absolute path and translate container → host path.
        # Container: /home/vscode/.ghq/... → Host: $HOST_HOME/.ghq/...
        set -l abs_path (realpath "$target" 2>/dev/null; or echo "$target")
        set -l host_home (set -q HOST_HOME; and echo $HOST_HOME; or echo $HOME)
        set -l host_path (string replace "$HOME/.ghq/" "$host_home/.ghq/" -- "$abs_path")
        printf '%s' "$host_path" | socat - TCP:127.0.0.1:12346 2>/dev/null
    end
    or begin
        echo "open: failed to connect to host bridge (is devup running?)" >&2
        return 1
    end
end
