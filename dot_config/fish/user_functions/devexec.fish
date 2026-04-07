function devexec --description "Run command in mono-local devcontainer (non-interactive)"
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devexec <command...>"
        echo ""
        echo "Run a command inside the mono-local devcontainer."
        echo "If pwd is under ~/.ghq, runs at the mirrored container path."
        echo "Otherwise runs at /home/vscode. mise shims are on PATH."
        return 0
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "No running mono-local container. Run: devup" >&2
        return 1
    end

    set -l workdir /home/vscode
    set -l pwd_real (realpath (pwd) 2>/dev/null)
    set -l ghq_real (realpath "$HOME/.ghq" 2>/dev/null)
    if test -n "$ghq_real"; and test -n "$pwd_real"; and string match -q "$ghq_real*" -- $pwd_real
        set -l rel (string sub -s (math (string length $ghq_real) + 1) $pwd_real)
        set workdir "/home/vscode/.ghq$rel"
    end

    docker exec -u vscode -w $workdir $cid \
        sh -c 'export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"; exec "$@"' _ $argv
end
