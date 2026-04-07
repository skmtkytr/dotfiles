function devscp --description "Copy files to/from mono-local devcontainer"
    if contains -- --help $argv; or test (count $argv) -eq 0
        echo "Usage: devscp <local-path> [container-path]"
        echo "       devscp --get <container-path> [local-path]"
        echo ""
        echo "Copy files between host and the mono-local devcontainer."
        echo "Default container destination is /home/vscode/."
        echo ""
        echo "Note: ~/.ghq and ~/.local/share/chezmoi are bind-mounted, so files"
        echo "in those trees are already shared without copying."
        return 0
    end

    set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    if test -z "$cid"
        echo "No running mono-local container." >&2
        return 1
    end

    set -l get_mode 0
    set -l positionals
    for arg in $argv
        switch $arg
            case --get
                set get_mode 1
            case '*'
                set -a positionals $arg
        end
    end

    set -l src $positionals[1]
    set -l dest ""
    if test (count $positionals) -ge 2
        set dest $positionals[2]
    end

    if test -z "$src"
        echo "Error: source path required" >&2
        return 1
    end

    if test $get_mode -eq 1
        if test -z "$dest"
            set dest .
        end
        echo "==> copying $src from container to $dest"
        docker cp "$cid:$src" "$dest"
    else
        if test -z "$dest"
            set dest /home/vscode/
        end
        echo "==> copying $src to container:$dest"
        docker cp "$src" "$cid:$dest"
        and docker exec $cid chown -R vscode:vscode "$dest" 2>/dev/null
    end
end
