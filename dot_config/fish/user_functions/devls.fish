function devls --description "Show mono-local devcontainer status"
    if contains -- --help -h $argv
        echo "Usage: devls"
        echo ""
        echo "Show the mono-local devcontainer status (running / stopped / absent)."
        return 0
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -n "$cid"
        set -l image (docker inspect --format '{{.Config.Image}}' $cid 2>/dev/null)
        set -l started (docker inspect --format '{{.State.StartedAt}}' $cid 2>/dev/null)
        printf "%-12s  %s\n" mono-local running
        printf "  cid:     %s\n" (string sub -l 12 $cid)
        printf "  image:   %s\n" $image
        printf "  started: %s\n" $started
        return 0
    end

    set -l stopped_cid (docker ps -aq --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -n "$stopped_cid"
        printf "%-12s  %s\n" mono-local stopped
        return 0
    end

    echo "No mono-local devcontainer (run: devup)"
end
