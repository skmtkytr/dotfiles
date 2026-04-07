function devscp --description "Copy files to/from devcontainer"
    # Ensure docker is available
    _ensure_commands_exist docker; or return 1
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devscp <local-path> [container-path] [owner/repo]"
        echo "       devscp --get <container-path> [local-path] [owner/repo]"
        echo ""
        echo "Copy files between local machine and devcontainer."
        echo "Searches per-repo container first, then mono container."
        echo "Default container path is /workspace/ (per-repo) or ghq path (mono)."
        echo ""
        echo "  devscp ./file.txt                      # → container"
        echo "  devscp --get /workspace/file.txt        # ← from container"
        return 0
    end

    # --- Parse arguments ---
    set -l get_mode 0
    set -l project ""
    set -l src ""
    set -l dest ""

    set -l positionals
    for arg in $argv
        switch $arg
            case --get
                set get_mode 1
            case '*/*'
                if string match -qr '^[^./][^/]*/[^/]+$' -- $arg; and not test -e $arg
                    set project $arg
                else
                    set -a positionals $arg
                end
            case '*'
                set -a positionals $arg
        end
    end

    set src $positionals[1]
    if test (count $positionals) -ge 2
        set dest $positionals[2]
    end

    if test -z "$src"
        echo "Error: source path required" >&2
        return 1
    end

    if test -z "$project"
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

    if test $get_mode -eq 1
        if test -z "$dest"
            set dest .
        end
        echo "==> Copying $src from container to $dest"
        $_found_docker_cmd cp "$_found_cid:$src" "$dest"
        and $_found_docker_cmd exec -u vscode "$_found_cid" chown -R (id -u):(id -g) "$src" 2>/dev/null
        or true
    else
        if test -z "$dest"
            set dest "$_found_workdir/"
        end
        echo "==> Copying $src to container:$dest"
        $_found_docker_cmd cp "$src" "$_found_cid:$dest"
        $_found_docker_cmd exec $_found_cid chown -R vscode:vscode "$dest" 2>/dev/null
    end

    and echo "Done."
    or echo "Error: copy failed" >&2
end
