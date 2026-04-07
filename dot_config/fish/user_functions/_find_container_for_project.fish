function _find_container_for_project --description "Find container for project (per-repo or mono)"
    # Usage: _find_container_for_project <owner/repo>
    # Sets: _found_cid, _found_workdir, _found_docker_cmd, _found_docker_host_env
    #
    # Search order:
    #   1. Per-repo container (label=devcontainer.project=owner/repo)
    #   2. Mono container (label=devcontainer.project=mono)
    #      workdir = /home/vscode/.ghq/github.com/owner/repo

    set -g _found_cid ""
    set -g _found_workdir ""
    set -g _found_docker_cmd docker
    set -g _found_docker_host_env ""

    set -l project $argv[1]
    set -l owner (string split / $project)[1]
    set -l repo (string split / $project)[2]

    # 1. Try per-repo container
    _resolve_docker_host $owner $repo
    set -l cid ($_docker_cmd ps -q --filter "label=devcontainer.project=$project" 2>/dev/null)

    if test -n "$cid"
        set _found_cid $cid
        set _found_workdir /workspace
        set _found_docker_cmd $_docker_cmd
        set _found_docker_host_env $_docker_host_env
        return 0
    end

    # 2. Try mono container (reuse _resolve_docker_host with mono meta)
    _resolve_docker_host mono ""
    set -l mono_cid ($_docker_cmd ps -q --filter "label=devcontainer.project=mono" 2>/dev/null)

    if test -n "$mono_cid"
        set _found_cid $mono_cid
        set _found_workdir "/home/vscode/.ghq/github.com/$owner/$repo"
        set _found_docker_cmd $_docker_cmd
        set _found_docker_host_env $_docker_host_env
        return 0
    end

    return 1
end
