function devport --description "Forward local port to devcontainer port"
    # Ensure required helper and external commands
    _ensure_commands_exist docker socat lsof pkill; or return 1
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devport <port> [owner/repo] [stop]"
        echo "       devport <local_port>:<container_port> [owner/repo] [stop]"
        echo ""
        echo "Forward a local port to a devcontainer port."
        echo "Searches per-repo container first, then mono container."
        echo ""
        echo "  devport 5173                        # same port on both sides"
        echo "  devport 5173 owner/repo             # explicit project"
        echo "  devport 5174:5173 owner/repo        # local 5174 → container 5173"
        echo "  devport 5173 stop                   # stop forwarding"
        echo "  devport 5173 owner/repo stop        # stop explicit"
        echo ""
        echo "Then open http://localhost:<local_port> in your local browser."
        echo ""
        echo "NOTE: Dev server must bind to 0.0.0.0, not localhost."
        return 0
    end

    # --- Parse arguments ---
    set -l local_port ""
    set -l container_port ""
    set -l project ""
    set -l action start

    for arg in $argv
        switch $arg
            case stop
                set action stop
            case '*:*'
                if string match -qr '^\d+:\d+$' $arg
                    set local_port (string split : $arg)[1]
                    set container_port (string split : $arg)[2]
                else
                    set project $arg
                end
            case '*/*'
                set project $arg
            case '*'
                if string match -qr '^\d+$' $arg
                    set local_port $arg
                    set container_port $arg
                end
        end
    end

    if test -z "$local_port"
        echo "Error: port number required"
        return 1
    end

    if test -z "$project"
        _detect_project_from_cwd
        set project $_detected_project
    end

    if test -z "$project"
        echo "Error: cannot detect project. Specify owner/repo or run from a ghq directory." >&2
        return 1
    end

    set -l owner (string split / $project)[1]
    set -l repo (string split / $project)[2]
    set -l pid_file "$HOME/.devcontainers/$owner/$repo/port-$local_port.pid"

    # --- Stop ---
    if test "$action" = stop
        _safe_kill_pidfile "$pid_file"
        pkill -f "socat.*TCP-LISTEN:$local_port" 2>/dev/null || true
        echo "Port $local_port forwarding stopped"
        return 0
    end

    # --- Find container ---
    if not _find_container_for_project $project
        echo "Error: no running container for $project"
        return 1
    end

    # Check if container uses host network (socat not needed)
    set -l net_mode ($_found_docker_cmd inspect --format '{{.HostConfig.NetworkMode}}' $_found_cid 2>/dev/null)
    if test "$net_mode" = host
        echo "Container uses host network — port $container_port is already accessible."
        echo "Open: http://localhost:$container_port"
        return 0
    end

    # Kill existing forwarding on this local port
    if test -f "$pid_file"
        set -l old_pid (cat "$pid_file" 2>/dev/null)
        if test -n "$old_pid"
            kill -- -$old_pid 2>/dev/null
            kill $old_pid 2>/dev/null
        end
        rm -f "$pid_file"
    end

    # --- Start socat proxy ---
    _ensure_pid_dir "$pid_file"; or return 1
    if test -n "$_found_docker_host_env"
        set -l escaped_host (string replace -a ':' '\\:' $_found_docker_host_env)
        bash -c 'trap "" HUP; exec socat "$@"' _ \
            "TCP-LISTEN:$local_port,fork,reuseaddr" \
            "SYSTEM:docker -H $escaped_host exec -i $_found_cid socat STDIO TCP\\:0.0.0.0\\:$container_port" &
    else
        bash -c 'trap "" HUP; exec socat "$@"' _ \
            "TCP-LISTEN:$local_port,fork,reuseaddr" \
            "SYSTEM:docker exec -i $_found_cid socat STDIO TCP\\:0.0.0.0\\:$container_port" &
    end
    set -l socat_pid $last_pid
    disown $socat_pid 2>/dev/null

    echo $socat_pid >"$pid_file"

    sleep 1

    if command lsof -i :$local_port >/dev/null 2>&1
        echo "Forwarding localhost:$local_port → container:$container_port ($project)"
        echo "Open: http://localhost:$local_port"
    else
        _safe_kill_pidfile "$pid_file"
        echo "socat proxy failed to start (is socat installed?)"
        return 1
    end
end
