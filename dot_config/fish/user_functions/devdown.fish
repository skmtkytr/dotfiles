function devdown --description "Stop and remove mono-local devcontainer"
    if contains -- --help -h $argv
        echo "Usage: devdown [--keep-volumes]"
        echo ""
        echo "Stop and remove the mono-local devcontainer."
        echo "Named volumes (mise/nvim/fish/tmux state) are also removed unless"
        echo "--keep-volumes is given. Bind mounts (~/.ghq, ~/.local/share/chezmoi)"
        echo "are NEVER touched (they are the host filesystem)."
        return 0
    end

    set -l keep_volumes 0
    for arg in $argv
        switch $arg
            case --keep-volumes
                set keep_volumes 1
            case '*'
                echo "Unknown argument: $arg"
                return 1
        end
    end

    set -l cids (docker ps -aq --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -n "$cids"
        echo "==> stopping mono-local container..."
        for c in $cids
            docker stop $c 2>/dev/null
            docker rm -f $c 2>/dev/null
        end
    else
        echo "  no mono-local container present"
    end

    if test $keep_volumes -eq 0
        echo "==> removing named volumes..."
        for vol in devcontainer-mise-data devcontainer-nvim-data devcontainer-fish-data devcontainer-tmux-data
            if docker volume rm $vol 2>/dev/null
                echo "  removed: $vol"
            end
        end
    else
        echo "  keeping volumes (--keep-volumes)"
    end

    # Kill host-side bridges left over from devup
    pkill -f "socat.*TCP-LISTEN:12345" 2>/dev/null
    pkill -f "socat.*TCP-LISTEN:12346" 2>/dev/null

    rm -rf "$HOME/.devcontainers/mono-local"

    echo "==> mono-local removed."
end
