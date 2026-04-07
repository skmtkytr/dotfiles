function devup --description "Start mono-local devcontainer"
    if contains -- --help $argv
        echo "Usage: devup [--sync] [devcontainer up options...]"
        echo ""
        echo "Start the mono-local devcontainer for skmtkytr/dotfiles."
        echo "Bind-mounts ~/.ghq and ~/.local/share/chezmoi from host."
        echo "Inside the container, projects live under ~/.ghq/github.com/owner/repo."
        echo ""
        echo "Options:"
        echo "  --sync                       Re-run chezmoi apply inside running container"
        echo "  --remove-existing-container  Remove and recreate the container"
        echo "  --rebuild-no-cache           Rebuild image without Docker cache"
        echo ""
        echo "Examples:"
        echo "  devup"
        echo "  devup --remove-existing-container"
        echo "  devup --sync"
        return 0
    end

    set -l dotfiles_dir "$HOME/.local/share/chezmoi"
    set -l config "$dotfiles_dir/.devcontainer/devcontainer.json"

    if not test -f "$config"
        echo "devcontainer config not found: $config"
        return 1
    end

    # --- Parse arguments ---
    set -l sync_mode 0
    set -l extra_args
    for arg in $argv
        switch $arg
            case --sync
                set sync_mode 1
            case '*'
                set -a extra_args $arg
        end
    end

    # --- Sync mode: re-run chezmoi apply inside container ---
    if test $sync_mode -eq 1
        set -l cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
        if test -z "$cid"
            echo "no running mono-local container"
            return 1
        end
        echo "==> chezmoi apply inside container..."
        docker exec -u vscode $cid \
            bash -lc 'PATH=/usr/local/bin:$PATH chezmoi apply --no-tty'
        return $status
    end

    set -l meta_dir "$HOME/.devcontainers/mono-local"
    mkdir -p "$meta_dir"

    echo "==> mono-local devcontainer"

    # Warn about unpushed dotfiles commits
    if test -d "$dotfiles_dir/.git"
        git -C "$dotfiles_dir" fetch origin main --quiet 2>/dev/null
        set -l unpushed (git -C "$dotfiles_dir" log origin/main..HEAD --oneline 2>/dev/null)
        if test -n "$unpushed"
            set_color yellow
            echo "  WARNING: dotfiles has unpushed commits:"
            for line in $unpushed
                echo "    $line"
            end
            set_color normal
        end
    end

    # --- Host-side SSH agent TCP bridge (1Password) ---
    echo "==> starting SSH agent bridge..."
    pkill -f "socat.*TCP-LISTEN:12345" 2>/dev/null
    set -l ssh_sock "$HOME/.ssh/agent.sock"
    if test -S "$ssh_sock"
        bash -c 'trap "" HUP; exec socat "$@"' _ \
            "TCP-LISTEN:12345,fork,reuseaddr,bind=127.0.0.1" \
            "UNIX-CONNECT:$ssh_sock" &
        disown $last_pid 2>/dev/null
        echo "  SSH agent bridge: localhost:12345 → $ssh_sock"
    else
        echo "  WARN: ~/.ssh/agent.sock not found, skipping SSH bridge"
    end

    # --- Host-side open bridge (container `open` → host opener) ---
    echo "==> starting open bridge..."
    pkill -f "socat.*TCP-LISTEN:12346" 2>/dev/null
    set -l open_cmd open
    if test (uname) = Linux
        set open_cmd xdg-open
    end
    bash -c 'trap "" HUP; while true; do
      socat TCP-LISTEN:12346,reuseaddr,bind=127.0.0.1 EXEC:"xargs '$open_cmd'",nofork 2>/dev/null
    done' &
    disown $last_pid 2>/dev/null
    echo "  open bridge: localhost:12346 → host $open_cmd"

    # --- devcontainer up ---
    echo "==> starting container..."
    set -l up_args \
        --config "$config" \
        --id-label "devcontainer.project=mono-local" \
        --workspace-folder "$dotfiles_dir"

    set -l up_tmpfile (mktemp /tmp/devup.XXXXXX)
    devcontainer up $up_args $extra_args 2>&1 | tee $up_tmpfile
    set -l up_status $pipestatus[1]

    if test $up_status -ne 0
        rm -f $up_tmpfile
        echo "devcontainer up failed"
        return 1
    end

    set -l cid (string match -r '"containerId":"([^"]+)"' < $up_tmpfile | tail -1)
    rm -f $up_tmpfile
    if test -z "$cid"
        set cid (docker ps -q --filter "label=devcontainer.project=mono-local" 2>/dev/null)
    end
    if test -z "$cid"
        echo "container not found after devcontainer up"
        return 1
    end

    docker update --restart unless-stopped $cid 2>/dev/null

    echo "==> running setup.sh..."
    docker exec -u vscode $cid \
        bash /home/vscode/.local/share/chezmoi/.devcontainer/setup.sh
    or echo "  WARN: setup.sh had errors (non-fatal)"

    # --- Save meta ---
    set -l created_at (date -u +%Y-%m-%dT%H:%M:%SZ)
    printf '%s\n' \
        "# devup meta – generated automatically" \
        "PROJECT=mono-local" \
        "CONTAINER_ID=$cid" \
        "CREATED_AT=$created_at" >"$meta_dir/.devup-meta"

    echo "==> ready! use:"
    echo "  devfish"
end
