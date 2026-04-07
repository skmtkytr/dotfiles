function devnvimserver --description "Start/stop nvim server in mono-local devcontainer"
    if contains -- --help -h $argv
        echo "Usage: devnvimserver [port] [stop]"
        echo ""
        echo "Start a headless nvim server inside the mono-local devcontainer."
        echo "The container uses --network=host, so the listening port is"
        echo "directly reachable on the host with no proxy."
        echo ""
        echo "  devnvimserver         # start, port 6666 (auto-increment if busy)"
        echo "  devnvimserver 7777    # start, port 7777"
        echo "  devnvimserver stop    # stop server"
        echo ""
        echo "Working directory mirrors host pwd if under ~/.ghq, else /home/vscode."
        echo ""
        echo "Connect: nvim --server localhost:<port> --remote-ui"
        return 0
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "No running mono-local container. Run: devup"
        return 1
    end

    set -l action start
    set -l port 6666
    for arg in $argv
        switch $arg
            case stop
                set action stop
            case '*'
                if string match -qr '^\d+$' $arg
                    set port $arg
                end
        end
    end

    if test "$action" = stop
        docker exec $cid pkill -f "nvim --headless" 2>/dev/null
        echo "nvim server stopped"
        return 0
    end

    # Auto-find a free port
    while command lsof -i :$port >/dev/null 2>&1
        set port (math $port + 1)
    end

    # Determine container working dir from host pwd
    set -l workdir /home/vscode
    set -l pwd_real (realpath (pwd) 2>/dev/null)
    set -l ghq_real (realpath "$HOME/.ghq" 2>/dev/null)
    if test -n "$ghq_real"; and test -n "$pwd_real"; and string match -q "$ghq_real*" -- $pwd_real
        set -l rel (string sub -s (math (string length $ghq_real) + 1) $pwd_real)
        set workdir "/home/vscode/.ghq$rel"
    end

    # Kill any existing server
    docker exec $cid pkill -f "nvim --headless" 2>/dev/null
    sleep 1

    docker exec -d -u vscode -e NVIM_HEADLESS_SERVER=1 $cid \
        sh -c "export PATH=\"\$HOME/.local/share/mise/shims:\$HOME/.local/bin:\$PATH\"; cd $workdir; nvim --headless --listen 0.0.0.0:$port"
    sleep 2

    if not docker exec $cid pgrep -f "nvim --headless" >/dev/null 2>&1
        echo "nvim server failed to start"
        return 1
    end

    echo "nvim server started (host network, port $port, workdir: $workdir)"
    echo "Connect: nvim --server localhost:$port --remote-ui"
end
