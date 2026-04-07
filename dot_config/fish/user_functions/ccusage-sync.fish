function ccusage-sync --description "Sync Claude Code session data from devcontainers to local"
    if contains -- --help -h $argv
        echo "Usage: ccusage-sync [owner/repo]"
        echo ""
        echo "Copy session data (projects/*.jsonl) from the shared devcontainer"
        echo "claude-config volume to local ~/.claude/projects/ so ccusage can"
        echo "aggregate all usage in one place."
        echo ""
        echo "  ccusage-sync              # sync via any running container"
        echo "  ccusage-sync owner/repo   # sync via specific container"
        echo ""
        echo "All containers share the claude-config volume, so connecting"
        echo "to any single running container syncs all session data."
        return 0
    end

    set -l local_dir "$HOME/.claude/projects"
    mkdir -p "$local_dir"

    # Find a running container to access the shared volume
    set -l via_project ""
    set -l cid ""

    if test (count $argv) -ge 1; and string match -q '*/*' -- $argv[1]
        # Explicit container
        set via_project $argv[1]
        set -l owner (string split / $via_project)[1]
        set -l repo (string split / $via_project)[2]
        _resolve_docker_host $owner $repo
        set cid ($_docker_cmd ps -q --filter "label=devcontainer.project=$via_project" 2>/dev/null)
    else
        # Find first running container
        set -l base_dir "$HOME/.devcontainers"
        if test -d "$base_dir"
            for meta_file in $base_dir/*/*/.devup-meta
                test -f "$meta_file" || continue
                set -l p (string match -r 'PROJECT=(.+)' < $meta_file)[2]
                test -n "$p" || continue

                set -l owner (string split / $p)[1]
                set -l repo (string split / $p)[2]
                _resolve_docker_host $owner $repo

                set -l c ($_docker_cmd ps -q --filter "label=devcontainer.project=$p" 2>/dev/null)
                if test -n "$c"
                    set via_project $p
                    set cid $c
                    break
                end
            end
        end
    end

    if test -z "$cid"
        echo "No running container found"
        return 1
    end

    echo "Syncing from shared volume (via $via_project)..."

    # List remote project dirs that have .jsonl files
    set -l remote_dirs ($_docker_cmd exec -u vscode $cid sh -c 'ls -d ~/.claude/projects/*/ 2>/dev/null' | string trim)

    if test -z "$remote_dirs"
        echo "No session data found"
        return 0
    end

    set -l synced 0
    for remote_dir in $remote_dirs
        set -l dirname (basename $remote_dir)
        mkdir -p "$local_dir/$dirname"

        # Get remote files with sizes: "size filename"
        set -l remote_entries ($_docker_cmd exec -u vscode $cid sh -c "stat -c '%s %n' $remote_dir*.jsonl 2>/dev/null || stat -f '%z %N' $remote_dir*.jsonl 2>/dev/null" | string trim)
        for entry in $remote_entries
            set -l remote_size (string split ' ' $entry)[1]
            set -l remote_file (string split ' ' $entry)[2]
            set -l filename (basename $remote_file)
            set -l local_file "$local_dir/$dirname/$filename"

            set -l needs_sync 0
            if not test -f "$local_file"
                set needs_sync 1
            else
                set -l local_size (stat -f '%z' "$local_file" 2>/dev/null; or stat -c '%s' "$local_file" 2>/dev/null)
                if test "$remote_size" -gt "$local_size"
                    set needs_sync 1
                end
            end

            if test $needs_sync -eq 1
                $_docker_cmd cp "$cid:$remote_file" "$local_file" 2>/dev/null
                and set synced (math $synced + 1)
            end
        end
    end

    echo "Synced $synced file(s)"
end
