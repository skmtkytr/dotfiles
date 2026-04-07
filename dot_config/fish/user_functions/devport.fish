function devport --description "Show port URL for mono-local devcontainer (host network)"
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devport <port>"
        echo ""
        echo "The mono-local devcontainer runs with --network=host, so any port"
        echo "the container binds to is directly reachable on the host with no"
        echo "forwarding needed. This command exists for muscle memory and just"
        echo "prints the URL."
        echo ""
        echo "Note: dev servers must bind to 0.0.0.0 (or localhost works too with"
        echo "host network), not a container-specific interface."
        return 0
    end

    set -l port $argv[1]
    if not string match -qr '^\d+$' $port
        echo "Error: port must be a number"
        return 1
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "WARN: no running mono-local container; URL will only work after devup"
    end

    echo "mono-local uses --network=host: container :$port == host :$port"
    echo "Open: http://localhost:$port"
end
