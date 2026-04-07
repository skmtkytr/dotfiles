function devdown --description "Stop and remove devcontainer"
    # Ensure docker is available
    _ensure_commands_exist docker; or return 1
    if contains -- --help -h $argv
        echo "Usage: devdown [owner/repo] [--keep-volume] [--mono]"
        echo "       devdown --all"
        echo ""
        echo "Stop and remove a devcontainer, its workspace volume, and meta files."
        echo "When no owner/repo is given, auto-detects from cwd (ghq path)."
        echo ""
        echo "Arguments:"
        echo "  owner/repo      Project to remove (auto-detected if omitted)"
        echo "  --mono          Remove the mono container"
        echo "  --keep-volume   Keep the workspace volume"
        echo "  --all           Remove all devcontainers (with confirmation)"
        echo ""
        echo "Examples:"
        echo "  devdown owner/repo              # remove container + volume + meta"
        echo "  devdown owner/repo --keep-volume # keep workspace volume"
        echo "  devdown --mono                   # remove mono container"
        echo "  devdown --all                    # remove everything"
        return 0
    end

    # --- Parse arguments ---
    set -l project ""
    set -l keep_volume 0
    set -l all_mode 0
    set -l mono_mode 0

    for arg in $argv
        switch $arg
            case --keep-volume
                set keep_volume 1
            case --all
                set all_mode 1
            case --mono
                set mono_mode 1
            case '*/*'
                set project $arg
            case '*'
                echo "Unknown argument: $arg"
                return 1
        end
    end

    set -l base_dir "$HOME/.devcontainers"

    # =================================================================
    # --mono mode: remove mono container
    # =================================================================
    if test $mono_mode -eq 1
        set -l meta_dir "$base_dir/mono"
        set -l meta_file "$meta_dir/.devup-meta"

        if not test -f "$meta_file"
            echo "No mono container meta found"
            return 1
        end

        set -l match (string match -r 'DOCKER_HOST=(.+)' < $meta_file)
        set -l docker_host_env ""
        if test (count $match) -ge 2
            set docker_host_env $match[2]
        end
        set -l docker_cmd docker
        if test -n "$docker_host_env"
            set docker_cmd docker -H $docker_host_env
        end

        set -l cids ($docker_cmd ps -aq --filter "label=devcontainer.project=mono" 2>/dev/null)
        if test -n "$cids"
            echo "  Stopping mono container..."
            for c in $cids
                $docker_cmd stop $c 2>/dev/null
                $docker_cmd rm -f $c 2>/dev/null
            end
        else
            echo "  No mono container found (already removed?)"
        end

        rm -rf "$meta_dir"
        echo "  Removed meta: $meta_dir"
        echo "==> Mono container removed (ghq volume preserved)."
        return 0
    end

    # =================================================================
    # --all mode: remove all devcontainers
    # =================================================================
    if test $all_mode -eq 1
        if test -n "$project"
            echo "Error: --all and owner/repo cannot be used together"
            return 1
        end

        if not test -d "$base_dir"
            echo "No devcontainers found"
            return 0
        end

        set -l projects
        for meta_file in $base_dir/*/*/.devup-meta
            if test -f "$meta_file"
                set -l match (string match -r 'PROJECT=(.+)' < $meta_file)
                if test (count $match) -ge 2; and test -n "$match[2]"
                    set -a projects $match[2]
                end
            end
        end
        # Include mono
        if test -f "$base_dir/mono/.devup-meta"
            set -a projects mono
        end

        if test (count $projects) -eq 0
            echo "No devcontainers found"
            return 0
        end

        echo "The following devcontainers will be removed:"
        for p in $projects
            echo "  - $p"
        end
        echo ""
        read -P "Remove all? (y/N) " -l confirm
        if not string match -qi y -- $confirm
            echo "Aborted."
            return 0
        end

        for p in $projects
            echo "==> Removing $p..."
            if test "$p" = mono
                devdown --mono
            else
                devdown $p
            end
        end
        return 0
    end

    # =================================================================
    # Auto-detect owner/repo from cwd (ghq path)
    # =================================================================
    if test -z "$project"
        _detect_project_from_cwd
        set project $_detected_project
    end

    # =================================================================
    # Single project mode
    # =================================================================
    if test -z "$project"
        echo "Usage: devdown [owner/repo] [--keep-volume] [--mono]"
        echo "       devdown --all"
        return 1
    end

    set -l owner (string split / $project)[1]
    set -l repo (string split / $project)[2]
    set -l meta_dir "$base_dir/$owner/$repo"
    set -l meta_file "$meta_dir/.devup-meta"

    if not test -f "$meta_file"
        echo "No meta file found for $project"
        return 1
    end

    _resolve_docker_host $owner $repo
    set -l match (string match -r 'VOLUME=(.+)' < $meta_file)
    set -l volume_name ""
    if test (count $match) -ge 2
        set volume_name $match[2]
    end

    # Kill socat proxy if PID file exists
    set -l pid_file "$meta_dir/socat.pid"
    if test -f "$pid_file"
        set -l socat_pid (cat "$pid_file" 2>/dev/null)
        if test -n "$socat_pid"
            kill -- -$socat_pid 2>/dev/null
            kill $socat_pid 2>/dev/null
        end
        rm -f "$pid_file"
    end

    # Stop and remove container(s)
    set -l cids ($_docker_cmd ps -aq --filter "label=devcontainer.project=$project" 2>/dev/null)
    if test -n "$cids"
        echo "  Stopping container(s)..."
        for c in $cids
            $_docker_cmd stop $c 2>/dev/null
            $_docker_cmd rm -f $c 2>/dev/null
        end
    else
        echo "  No container found (already removed?)"
    end

    # Remove workspace volume
    if test $keep_volume -eq 0; and test -n "$volume_name"
        echo "  Removing volume: $volume_name"
        $_docker_cmd volume rm $volume_name 2>/dev/null
        or echo "  WARN: volume removal failed (may not exist)"
    else if test $keep_volume -eq 1
        echo "  Keeping volume: $volume_name"
    end

    rm -rf "$meta_dir"
    echo "  Removed meta: $meta_dir"

    set -l owner_dir "$base_dir/$owner"
    if test -d "$owner_dir"
        rmdir "$owner_dir" 2>/dev/null
    end

    echo "==> $project removed."
end
