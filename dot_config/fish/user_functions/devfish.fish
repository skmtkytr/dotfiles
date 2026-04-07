function devfish --description "Open fish shell in mono-local devcontainer"
    if contains -- --help -h $argv
        echo "Usage: devfish [path]"
        echo ""
        echo "Open a fish shell inside the mono-local devcontainer."
        echo "If pwd is under ~/.ghq, opens at the mirrored container path."
        echo "Otherwise opens at /home/vscode."
        return 0
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "No running mono-local container. Run: devup"
        return 1
    end

    set -l workdir /home/vscode
    if test -n "$argv[1]"
        set workdir $argv[1]
    else
        set -l pwd_real (realpath (pwd) 2>/dev/null)
        set -l ghq_real (realpath "$HOME/.ghq" 2>/dev/null)
        if test -n "$ghq_real"; and test -n "$pwd_real"; and string match -q "$ghq_real*" -- $pwd_real
            set -l rel (string sub -s (math (string length $ghq_real) + 1) $pwd_real)
            set workdir "/home/vscode/.ghq$rel"
        end
    end

    docker exec -it -u vscode -w $workdir $cid fish
end
