function devnvimserver --description "Start/stop nvim server in devcontainer"
    # Ensure required helper and external commands
    _ensure_commands_exist docker socat lsof pkill; or return 1
    if contains -- --help -h $argv
        echo "Usage: devnvimserver [owner/repo] [port] [stop]"
        echo ""
        echo "Start or stop a headless nvim server inside a devcontainer with socat proxy."
        echo "Searches per-repo container first, then mono container."
        echo ""
        echo "Local mode:   devnvimserver [port]"
        echo "Remote mode:  devnvimserver owner/repo [port]"
        echo "Stop:         devnvimserver [owner/repo] stop"
        echo ""
        echo "Arguments:"
        echo "  owner/repo   Project identifier for remote devcontainer"
        echo "  port         Host port to listen on (default: 6666, auto-increments)"
        echo "  stop         Kill nvim server and socat proxy"
        echo ""
        echo "Examples:"
        echo "  devnvimserver                    # start local, port 6666"
        echo "  devnvimserver 7777               # start local, port 7777"
        echo "  devnvimserver owner/repo         # start remote"
        echo "  devnvimserver owner/repo stop    # stop remote"
        echo ""
        echo "Connect: nvim --server localhost:<port> --remote-ui"
        return 0
    end

    # --- Parse arguments ---
    set -l project ""
    set -l action start
    set -l port ""

    for arg in $argv
        switch $arg
            case stop
                set action stop
            case '*/*'
                set project $arg
            case '*'
                if string match -qr '^\d+$' $arg
                    set port $arg
                end
        end
    end

    # --- PID file path ---
    set -l pid_file ""
    if test -n "$project"
        set -l owner (string split / $project)[1]
        set -l repo (string split / $project)[2]
        set pid_file "$HOME/.devcontainers/$owner/$repo/socat.pid"
    else
        set -l workspace_hash (printf '%s' (pwd) | md5sum 2>/dev/null | string split ' ')[1]
        if test -z "$workspace_hash"
            set workspace_hash (printf '%s' (pwd) | md5)
        end
        set pid_file "$HOME/.devcontainers/local/$workspace_hash/socat.pid"
    end

    # --- Find container ---
    set -l cid ""
    set -l docker_cmd docker
    set -l docker_host_env ""
    set -l workdir ""

    if test -n "$project"
        if _find_container_for_project $project
            set cid $_found_cid
            set docker_cmd $_found_docker_cmd
            set docker_host_env $_found_docker_host_env
            set workdir $_found_workdir
        end
    else
        # Local mode: find by pwd
        set -l workspace (pwd)
        set cid (docker ps -q --filter "label=devcontainer.local_folder=$workspace" 2>/dev/null)
        set workdir $workspace
    end

    if test -z "$cid"
        if test -n "$project"
            echo "No devcontainer found for $project"
        else
            echo "No devcontainer found for "(pwd)
        end
        return 1
    end

    # --- Helper: kill socat by PID file ---
    function _devnvimserver_kill_socat --no-scope-shadowing
        _safe_kill_pidfile "$pid_file"
        pkill -f "socat.*docker exec.*$cid" 2>/dev/null || true
    end

    # --- Stop ---
    if test "$action" = stop
        $docker_cmd exec $cid pkill -f "nvim --headless" 2>/dev/null
        _devnvimserver_kill_socat
        echo "nvim server stopped"
        functions -e _devnvimserver_kill_socat
        return
    end

    # --- Auto-find port ---
    if test -z "$port"
        set port 6666
        while command lsof -i :$port >/dev/null 2>&1
            set port (math $port + 1)
        end
    end

    # Kill existing server and proxy if any
    $docker_cmd exec $cid pkill -f "nvim --headless" 2>/dev/null
    _devnvimserver_kill_socat
    functions -e _devnvimserver_kill_socat
    sleep 1

    # Check if container uses host network (socat not needed)
    set -l net_mode ($docker_cmd inspect --format '{{.HostConfig.NetworkMode}}' $cid 2>/dev/null)
    set -l is_host_network 0
    if test "$net_mode" = host
        set is_host_network 1
    end

    # Start nvim inside the container (listen on $port directly if host network)
    set -l listen_port 6666
    if test $is_host_network -eq 1
        set listen_port $port
    end
    $docker_cmd exec -d -u vscode -e NVIM_HEADLESS_SERVER=1 $cid \
        sh -c "export PATH=\"\$HOME/.local/share/mise/shims:\$HOME/.local/bin:\$PATH\"; cd $workdir; nvim --headless --listen 0.0.0.0:$listen_port"
    sleep 2

    if not $docker_cmd exec $cid pgrep -f "nvim --headless" >/dev/null 2>&1
        echo "nvim server failed to start"
        return 1
    end

    if test $is_host_network -eq 1
        # Host network: nvim is directly accessible, no socat needed
        echo "nvim server started (host network, port $port)"
        echo "Connect: nvim --server localhost:$port --remote-ui"
    else
        mkdir -p (dirname "$pid_file")

        # Start socat proxy (use helpers for safe pid dir and SYSTEM: construction)
        _ensure_pid_dir "$pid_file"; or return 1
        if test -n "$docker_host_env"
            set -l escaped_host (string replace -a ':' '\\:' $docker_host_env)
            bash -c 'trap "" HUP; exec socat "$@"' _ \
                "TCP-LISTEN:$port,fork,reuseaddr" \
                "SYSTEM:docker -H $escaped_host exec -i $cid socat STDIO TCP\\:127.0.0.1\\:6666" &
        else
            bash -c 'trap "" HUP; exec socat "$@"' _ \
                "TCP-LISTEN:$port,fork,reuseaddr" \
                "SYSTEM:docker exec -i $cid socat STDIO TCP\\:127.0.0.1\\:6666" &
        end
        set -l socat_pid $last_pid
        disown $socat_pid 2>/dev/null

        echo $socat_pid >"$pid_file"

        sleep 1

        if command lsof -i :$port >/dev/null 2>&1
            echo "nvim server started (host:$port → container:6666)"
            echo "Connect: nvim --server localhost:$port --remote-ui"
        else
            _safe_kill_pidfile "$pid_file"
            echo "socat proxy failed to start (is socat installed? brew install socat)"
            return 1
        end
    end
end
