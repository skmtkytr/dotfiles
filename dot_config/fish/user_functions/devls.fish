function devls --description "List remote devcontainers"
    # Ensure docker is available (used to detect container status)
    _ensure_commands_exist docker; or return 1
    if contains -- --help -h $argv
        echo "Usage: devls"
        echo ""
        echo "List all registered remote devcontainers and their status."
        echo "Includes both per-repo and mono containers."
        echo ""
        echo "Output columns: PROJECT  STATUS  HOST  CLONE_URL"
        return 0
    end

    set -l base_dir "$HOME/.devcontainers"

    if not test -d "$base_dir"
        echo "No devcontainers found (no ~/.devcontainers/ directory)"
        return 0
    end

    set -l found 0

    printf "%-30s  %-8s  %-30s  %s\n" PROJECT STATUS HOST CLONE_URL
    echo (string repeat -n 100 -)

    # Per-repo containers
    for meta_file in $base_dir/*/*/.devup-meta
        if not test -f "$meta_file"
            continue
        end

        set found (math $found + 1)

        set -l project (string match -r 'PROJECT=(.+)' < $meta_file)[2]
        set -l docker_host (string match -r 'DOCKER_HOST=(.+)' < $meta_file)[2]
        set -l clone_url (string match -r 'CLONE_URL=(.+)' < $meta_file)[2]

        set -l docker_cmd docker
        if test -n "$docker_host" -a "$docker_host" != local
            set docker_cmd docker -H $docker_host
        end

        set -l cid ($docker_cmd ps -q --filter "label=devcontainer.project=$project" 2>/dev/null)
        set -l status_str stopped
        if test -n "$cid"
            set status_str running
        end

        set -l host_str local
        if test -n "$docker_host" -a "$docker_host" != local
            set host_str $docker_host
        end

        printf "%-30s  %-8s  %-30s  %s\n" $project $status_str $host_str $clone_url
    end

    # Mono container
    set -l mono_meta "$base_dir/mono/.devup-meta"
    if test -f "$mono_meta"
        set found (math $found + 1)

        set -l docker_host (string match -r 'DOCKER_HOST=(.+)' < $mono_meta)[2]

        set -l docker_cmd docker
        if test -n "$docker_host" -a "$docker_host" != local
            set docker_cmd docker -H $docker_host
        end

        set -l cid ($docker_cmd ps -q --filter "label=devcontainer.project=mono" 2>/dev/null)
        set -l status_str stopped
        if test -n "$cid"
            set status_str running
        end

        set -l host_str local
        if test -n "$docker_host" -a "$docker_host" != local
            set host_str $docker_host
        end

        printf "%-30s  %-8s  %-30s  %s\n" "mono (shared)" $status_str $host_str "(ghq)"
    end

    if test $found -eq 0
        echo "No devcontainers found"
    end
end
