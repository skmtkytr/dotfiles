function ccusage-sync --description "Sync Claude Code session data from mono-local devcontainer to host"
    if contains -- --help -h $argv
        echo "Usage: ccusage-sync"
        echo ""
        echo "Copy session data (projects/*.jsonl) from the mono-local devcontainer"
        echo "to local ~/.claude/projects/ so ccusage can aggregate all usage."
        return 0
    end

    set -l local_dir "$HOME/.claude/projects"
    mkdir -p "$local_dir"

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "No running mono-local container"
        return 1
    end

    echo "Syncing from mono-local container..."

    # List remote project dirs that have .jsonl files
    set -l remote_dirs (docker exec -u vscode $cid sh -c 'ls -d ~/.claude/projects/*/ 2>/dev/null' | string trim)

    if test -z "$remote_dirs"
        echo "No session data found"
        return 0
    end

    set -l synced 0
    for remote_dir in $remote_dirs
        set -l dirname (basename $remote_dir)
        mkdir -p "$local_dir/$dirname"

        set -l remote_entries (docker exec -u vscode $cid sh -c "stat -c '%s %n' $remote_dir*.jsonl 2>/dev/null" | string trim)
        for entry in $remote_entries
            set -l remote_size (string split ' ' $entry)[1]
            set -l remote_file (string split ' ' $entry)[2]
            set -l filename (basename $remote_file)
            set -l local_file "$local_dir/$dirname/$filename"

            set -l needs_sync 0
            if not test -f "$local_file"
                set needs_sync 1
            else
                set -l local_size (stat -c '%s' "$local_file" 2>/dev/null)
                if test -n "$local_size"; and test "$remote_size" -gt "$local_size"
                    set needs_sync 1
                end
            end

            if test $needs_sync -eq 1
                docker cp "$cid:$remote_file" "$local_file" 2>/dev/null
                and set synced (math $synced + 1)
            end
        end
    end

    echo "Synced $synced file(s)"
end
