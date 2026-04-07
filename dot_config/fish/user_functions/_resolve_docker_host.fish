function _resolve_docker_host --description "Resolve DOCKER_HOST for devcontainer"
    # Usage: _resolve_docker_host <owner> <repo> [ssh_host_override]
    # Sets: _docker_host_env (e.g. "ssh://user@host"), _docker_cmd (e.g. "docker -H ...")
    #
    # Resolution order:
    #   1. ssh_host_override argument (converted to ssh:// if needed)
    #   2. DOCKER_HOST from meta file (~/.devcontainers/<owner>/<repo>/.devup-meta)
    #      "local" = explicitly local docker (no fallback to default host)
    #   3. $DEVUP_DEFAULT_HOST or ~/.config/devup/default_host

    set -g _docker_host_env ""
    set -g _docker_cmd docker

    set -l owner $argv[1]
    set -l repo $argv[2]

    # 1. Override from argument
    if set -q argv[3]; and test -n "$argv[3]"
        set _docker_host_env "ssh://$argv[3]"
    else
        # 2. Meta file
        set -l meta_file
        if test -n "$repo"
            set meta_file "$HOME/.devcontainers/$owner/$repo/.devup-meta"
        else
            set meta_file "$HOME/.devcontainers/$owner/.devup-meta"
        end
        if test -f "$meta_file"
            set -l match (string match -r 'DOCKER_HOST=(.+)' < $meta_file)
            if test (count $match) -ge 2
                if test "$match[2]" = local
                    # Explicitly local — skip default host fallback
                    set _docker_host_env ""
                    set _docker_cmd docker
                    return 0
                end
                set _docker_host_env $match[2]
            end
        end

        # 3. Default host fallback
        if test -z "$_docker_host_env"
            set -l default_host ""
            if set -q DEVUP_DEFAULT_HOST
                set default_host $DEVUP_DEFAULT_HOST
            else if test -f "$HOME/.config/devup/default_host"
                set default_host (string trim < "$HOME/.config/devup/default_host")
            end
            if test -n "$default_host"
                set _docker_host_env "ssh://$default_host"
            end
        end
    end

    if test -n "$_docker_host_env"
        set _docker_cmd docker -H $_docker_host_env
    end
end
