function devfish --description "Open fish shell in devcontainer"
    # Ensure docker is available
    _ensure_commands_exist docker; or return 1
    if contains -- --help -h $argv
        echo "Usage: devfish [owner/repo] [--mono]"
        echo ""
        echo "Open a fish shell inside a devcontainer."
        echo ""
        echo "  devfish              # auto-detect (per-repo → mono fallback)"
        echo "  devfish owner/repo   # explicit project"
        echo "  devfish --mono       # connect to mono container (home dir)"
        echo ""
        echo "When no argument is given, detects owner/repo from the current"
        echo "ghq directory and connects to the matching container."
        echo "Falls back to mono container, then local devcontainer."
        return 0
    end

    set -l project ""
    set -l mono_direct 0

    for arg in $argv
        switch $arg
            case --mono
                set mono_direct 1
            case '*/*'
                set project $arg
        end
    end

    # --mono without project: connect to mono container home dir
    if test $mono_direct -eq 1 -a -z "$project"
        _resolve_docker_host mono ""
        set -l cid ($_docker_cmd ps -q --filter "label=devcontainer.project=mono" 2>/dev/null)
        if test -n "$cid"
            $_docker_cmd exec -it -u vscode -w /home/vscode $cid fish
            return $status
        end
        echo "No running mono container found"
        return 1
    end

    if test -z "$project"
        _detect_project_from_cwd
        set project $_detected_project
    end

    # If we have a project, find container (per-repo → mono fallback)
    if test -n "$project"
        if _find_container_for_project $project
            $_found_docker_cmd exec -it -u vscode -w $_found_workdir $_found_cid fish
            return $status
        end
    end

    # Fallback: local devcontainer
    devcontainer exec --workspace-folder . fish $argv
    return $status
end
