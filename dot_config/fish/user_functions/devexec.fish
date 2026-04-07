function devexec --description "Run command in devcontainer (non-interactive)"
    # Ensure docker is available
    _ensure_commands_exist docker; or return 1
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devexec [owner/repo] <command...>"
        echo ""
        echo "Run a command inside a devcontainer (non-interactive)."
        echo "Searches per-repo container first, then mono container."
        echo ""
        echo "  devexec ls -la                  # auto-detect project from cwd"
        echo "  devexec owner/repo ls -la       # explicit project"
        echo "  devexec make test               # run tests"
        echo ""
        echo "Working directory is /workspace (per-repo) or ghq path (mono)."
        echo "mise shims are on PATH."
        return 0
    end

    set -l project ""
    set -l cmd_start 1

    # First arg is owner/repo if it contains '/'
    if string match -q '*/*' -- $argv[1]
        set project $argv[1]
        set cmd_start 2
    else
        _detect_project_from_cwd
        set project $_detected_project
    end

    if test -z "$project"
        echo "Error: cannot detect project. Specify owner/repo or run from a ghq directory." >&2
        return 1
    end

    if not _find_container_for_project $project
        echo "Error: no running container for $project" >&2
        return 1
    end

    set -l user_cmd $argv[$cmd_start..-1]
    if test (count $user_cmd) -eq 0
        echo "Error: no command specified" >&2
        return 1
    end

    $_found_docker_cmd exec -u vscode -w $_found_workdir $_found_cid \
        sh -c 'export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"; exec "$@"' _ $user_cmd
end
