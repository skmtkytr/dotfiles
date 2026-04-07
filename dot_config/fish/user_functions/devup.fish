function devup --description "Start devcontainer (local or remote)"
    if contains -- --help $argv
        echo "Usage: devup [<project>] [--host user@server] [--new] [--sync] [--mono] [devcontainer options...]"
        echo ""
        echo "Local mode:   devup"
        echo "Remote mode:  devup <project> --host user@server"
        echo "Mono mode:    devup --mono [<project>]"
        echo "New project:  devup --new <name> --host user@server"
        echo "Sync dotfiles: devup [<project>|--mono] --sync"
        echo ""
        echo "Arguments:"
        echo "  <project>          owner/repo, full URL (https, git@), or repo name"
        echo "  --host/-h <host>   Remote Docker host (e.g. user@server)"
        echo "  --mono             Use single shared container (repos via ghq)"
        echo "  --local            Force local Docker (skip remote host resolution)"
        echo "  --new              Create a new private GitHub repo first"
        echo "  --sync             Update dotfiles in running container"
        echo ""
        echo "Extra options (passed to devcontainer up):"
        echo "  --remove-existing-container  Remove and recreate the container"
        echo "  --rebuild-no-cache           Rebuild image without Docker cache"
        echo ""
        echo "Host resolution (in order):"
        echo "  1. --host argument"
        echo "  2. Saved from previous devup (~/.devcontainers/<owner>/<repo>/.devup-meta)"
        echo "  3. \$DEVUP_DEFAULT_HOST or ~/.config/devup/default_host"
        echo ""
        echo "Examples:"
        echo "  devup owner/repo                                  # per-repo container"
        echo "  devup --mono                                      # start mono container (remote)"
        echo "  devup --mono --local                                # start mono container (local)"
        echo "  devup --mono owner/repo                           # mono + ghq get repo"
        echo "  devup --mono --sync                               # sync dotfiles in mono"
        echo "  devup owner/repo -h me@sv                         # explicit host"
        echo "  devup --new myproject                              # create & remote"
        return 0
    end

    set -l dotfiles_dir "$HOME/.ghq/github.com/skmtkytr/dotfiles"
    set -l dotfiles_config "$dotfiles_dir/.devcontainer/devcontainer.json"
    set -l remote_config "$dotfiles_dir/.devcontainer/remote/devcontainer.json"
    set -l mono_config "$dotfiles_dir/.devcontainer/mono/devcontainer.json"
    set -l mono_local_config "$dotfiles_dir/.devcontainer/mono-local/devcontainer.json"

    if not test -f "$dotfiles_config"
        echo "Dotfiles devcontainer.json not found: $dotfiles_config"
        return 1
    end

    # --- Parse arguments ---
    set -l repo_url ""
    set -l docker_host ""
    set -l new_project ""
    set -l sync_mode 0
    set -l mono_mode 0
    set -l force_local 0
    set -l extra_args

    set -l i 1
    while test $i -le (count $argv)
        switch $argv[$i]
            case --host -h
                set i (math $i + 1)
                set docker_host $argv[$i]
            case --new
                set i (math $i + 1)
                if test $i -le (count $argv)
                    set new_project $argv[$i]
                end
            case --sync
                set sync_mode 1
            case --mono
                set mono_mode 1
            case --local
                set force_local 1
            case '-*'
                set -a extra_args $argv[$i]
            case '*'
                if test -z "$repo_url"
                    set repo_url $argv[$i]
                else
                    set -a extra_args $argv[$i]
                end
        end
        set i (math $i + 1)
    end

    # --- Validate exclusivity ---
    if test $sync_mode -eq 1 -a -n "$new_project"
        echo "Error: --sync and --new cannot be used together"
        return 1
    end
    if test $mono_mode -eq 1 -a -n "$new_project"
        echo "Error: --mono and --new cannot be used together"
        return 1
    end

    # --- Handle --new: create GitHub repo first ---
    if test -n "$new_project"
        if test -z "$docker_host"
            echo "Error: --new requires --host"
            return 1
        end
        if test -n "$repo_url"
            echo "Error: --new and <project> cannot be used together"
            return 1
        end

        if string match -q '*/*' -- $new_project
            set repo_url $new_project
        else
            set -l gh_user (gh api user -q .login 2>/dev/null)
            if test -z "$gh_user"
                echo "Error: cannot determine GitHub user (run gh auth login)"
                return 1
            end
            set repo_url "$gh_user/$new_project"
        end

        echo "==> Creating GitHub repo: $repo_url (private)..."
        gh repo create $repo_url --private
        or begin
            echo "Failed to create repo"
            return 1
        end
    end

    # =================================================================
    # MONO MODE
    # =================================================================
    if test $mono_mode -eq 1
        # Select config: local uses Dockerfile build (arm64 compatible)
        set -l active_mono_config $mono_config
        if test $force_local -eq 1
            set active_mono_config $mono_local_config
        end

        if not test -f "$active_mono_config"
            echo "Mono config not found: $active_mono_config"
            return 1
        end

        set -l meta_dir "$HOME/.devcontainers/mono"
        mkdir -p "$meta_dir"

        echo "==> Mono devcontainer"

        # Resolve DOCKER_HOST
        # --local forces local docker, otherwise: --host > meta > default
        set -l mono_docker_host_env ""
        set -l mono_docker_cmd docker

        if test $force_local -eq 1
            # Stay local, no remote host — skip all resolution
            set mono_docker_host_env ""
            set mono_docker_cmd docker
        else if test -n "$docker_host"
            set mono_docker_host_env "ssh://$docker_host"
        else
            # Meta file
            if test -f "$meta_dir/.devup-meta"
                set -l match (string match -r 'DOCKER_HOST=(.+)' < "$meta_dir/.devup-meta")
                if test (count $match) -ge 2
                    if test "$match[2]" = local
                        set mono_docker_host_env ""
                    else
                        set mono_docker_host_env $match[2]
                    end
                end
            end

            # Default host fallback
            if test -z "$mono_docker_host_env"
                set -l default_host ""
                if set -q DEVUP_DEFAULT_HOST
                    set default_host $DEVUP_DEFAULT_HOST
                else if test -f "$HOME/.config/devup/default_host"
                    set default_host (string trim < "$HOME/.config/devup/default_host")
                end
                if test -n "$default_host"
                    set mono_docker_host_env "ssh://$default_host"
                end
            end
        end

        if test -n "$mono_docker_host_env"
            set mono_docker_cmd docker -H $mono_docker_host_env
            echo "  Docker host: $mono_docker_host_env"
        end

        # Warn about unpushed dotfiles
        if test -d "$dotfiles_dir/.git"
            git -C "$dotfiles_dir" fetch origin master --quiet 2>/dev/null
            set -l unpushed (git -C "$dotfiles_dir" log origin/master..HEAD --oneline 2>/dev/null)
            if test -n "$unpushed"
                set_color yellow
                echo "  WARNING: dotfiles has unpushed commits:"
                for line in $unpushed
                    echo "    $line"
                end
                set_color normal
            end
        end

        # --sync mode for mono
        if test $sync_mode -eq 1
            if test $force_local -eq 1
                # Local: ~/.ghq is bind-mounted, ~/.config is symlinked to
                # ~/.ghq/.../dotfiles/config — changes on host are live instantly.
                echo "mono-local: dotfiles are live via bind mount + symlink, --sync is not needed."
                return 0
            end

            set -l cid ($mono_docker_cmd ps -q --filter "label=devcontainer.project=mono" 2>/dev/null)
            if test -z "$cid"
                echo "No running mono container found"
                return 1
            end

            echo "==> Syncing dotfiles in mono container..."
            $mono_docker_cmd exec -u vscode $cid sh -c 'cd "$HOME/dotfiles" && git fetch origin && git reset --hard origin/master'
            or begin
                echo "  ERROR: git sync failed"
                return 1
            end

            echo "==> Re-running setup.sh..."
            $mono_docker_cmd exec -u vscode $cid sh -c 'bash "$HOME/dotfiles/.devcontainer/setup.sh"'
            or echo "  WARN: setup.sh had errors (non-fatal)"

            echo "==> Dotfiles synced!"
            return 0
        end

        # Pull latest image (skip for --local, which builds from Dockerfile)
        if test $force_local -eq 0
            set -l image "ghcr.io/skmtkytr/devcontainer:latest"
            set -l old_digest ($mono_docker_cmd image inspect $image --format '{{index .RepoDigests 0}}' 2>/dev/null)
            echo "==> Pulling latest image..."
            $mono_docker_cmd pull $image 2>&1
            set -l new_digest ($mono_docker_cmd image inspect $image --format '{{index .RepoDigests 0}}' 2>/dev/null)

            if test -n "$old_digest" -a -n "$new_digest" -a "$old_digest" != "$new_digest"
                set_color yellow
                echo "  Image updated! Consider: devup --mono --remove-existing-container"
                set_color normal
            end
        end

        # devcontainer up
        echo "==> Starting mono container..."
        set -l up_args \
            --config "$active_mono_config" \
            --id-label "devcontainer.project=mono" \
            --workspace-folder "$dotfiles_dir"

        # Local: dotfiles already available via bind mount (~/.ghq), skip clone
        # Remote: clone dotfiles from GitHub
        if test $force_local -eq 0
            set -a up_args \
                --dotfiles-repository "https://github.com/skmtkytr/dotfiles.git" \
                --dotfiles-target-path "~/dotfiles" \
                --dotfiles-install-command ".devcontainer/setup.sh"
        end

        set -l up_tmpfile (mktemp /tmp/devup.XXXXXX)
        set -l env_args
        if test -n "$mono_docker_host_env"
            set env_args DOCKER_HOST=$mono_docker_host_env
        end
        env $env_args devcontainer up $up_args $extra_args 2>&1 | tee $up_tmpfile
        set -l up_status $pipestatus[1]

        if test $up_status -ne 0
            rm -f $up_tmpfile
            echo "devcontainer up failed"
            return 1
        end

        set -l cid (string match -r '"containerId":"([^"]+)"' < $up_tmpfile | tail -1)
        rm -f $up_tmpfile
        if test -z "$cid"
            set cid ($mono_docker_cmd ps -q --filter "label=devcontainer.project=mono" 2>/dev/null)
        end
        if test -z "$cid"
            echo "Container not found after devcontainer up"
            return 1
        end

        $mono_docker_cmd update --restart unless-stopped $cid 2>/dev/null

        # Local: run setup.sh from bind-mounted dotfiles
        # ~/.config will be symlinked to ~/.ghq/.../dotfiles/config (live, not a stale clone)
        if test $force_local -eq 1
            # Start host-side SSH agent TCP bridge (for 1Password signing in container).
            # Container connects to host.internal:12345 via socat.
            # Always use ~/.ssh/agent.sock (1Password symlink) rather than
            # $SSH_AUTH_SOCK which may point to macOS default agent.
            echo "==> Starting SSH agent bridge..."
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

            # Start host-side open bridge (container `open` → host `open`)
            echo "==> Starting open bridge..."
            pkill -f "socat.*TCP-LISTEN:12346" 2>/dev/null
            bash -c 'trap "" HUP; while true; do
              socat TCP-LISTEN:12346,reuseaddr,bind=127.0.0.1 EXEC:"xargs open",nofork 2>/dev/null
            done' &
            disown $last_pid 2>/dev/null
            echo "  Open bridge: localhost:12346 → host open"

            echo "==> Running setup.sh from bind-mounted dotfiles..."
            $mono_docker_cmd exec -u vscode $cid bash /home/vscode/.ghq/github.com/skmtkytr/dotfiles/.devcontainer/setup.sh 2>&1
            or echo "  WARN: setup.sh had errors (non-fatal)"
        end

        # If repo_url specified, ghq get it
        if test -n "$repo_url"
            _devup_parse_repo_url $repo_url
            or return 1
            set -l clone_url $_parsed_clone_url
            set -l owner $_parsed_owner
            set -l repo $_parsed_repo

            echo "==> Cloning $owner/$repo via ghq..."
            $mono_docker_cmd exec -u vscode $cid sh -c 'export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"; ghq get '"$clone_url" 2>&1
            or echo "  WARN: ghq get failed (may already exist or auth needed)"

            # Run mise install if .mise.toml exists
            set -l ghq_path "/home/vscode/.ghq/github.com/$owner/$repo"
            set -l has_mise ($mono_docker_cmd exec $cid sh -c "test -f $ghq_path/.mise.toml && echo yes" 2>/dev/null)
            if test "$has_mise" = yes
                echo "==> Running mise install..."
                $mono_docker_cmd exec -u vscode $cid sh -c "cd $ghq_path && export PATH=\"\$HOME/.local/share/mise/shims:\$HOME/.local/bin:\$PATH\" && mise install --yes" 2>&1
                or echo "  WARN: mise install had errors (non-fatal)"
            end
        end

        # Save meta file
        set -l created_at (date -u +%Y-%m-%dT%H:%M:%SZ)
        set -l saved_host $mono_docker_host_env
        if test $force_local -eq 1
            set saved_host local
        end
        printf '%s\n' \
            "# devup meta – generated automatically" \
            "DOCKER_HOST=$saved_host" \
            "PROJECT=mono" \
            "CLONE_URL=" \
            "VOLUME=" \
            "CONTAINER_ID=$cid" \
            "CREATED_AT=$created_at" >"$meta_dir/.devup-meta"

        echo "==> Ready! Use:"
        echo "  devfish --mono"
        if test -n "$repo_url"
            echo "  devfish $_parsed_owner/$_parsed_repo  (auto-detects mono)"
        end
        return 0
    end

    # =================================================================
    # Auto-detect owner/repo from cwd (ghq path)
    # =================================================================
    if test -z "$repo_url"
        _detect_project_from_cwd
        set repo_url $_detected_project
    end

    # =================================================================
    # LOCAL MODE (no project detected, no flags)
    # =================================================================
    if test -z "$repo_url"
        if test -n "$docker_host"
            echo "Error: --host requires a project (owner/repo)"
            echo "Usage: devup <project> --host user@server"
            return 1
        end
        devcontainer up --workspace-folder . --config "$dotfiles_config" $extra_args
        return $status
    end

    # Validate --local + --host exclusivity
    if test $force_local -eq 1 -a -n "$docker_host"
        echo "Error: --host and --local cannot be used together"
        return 1
    end

    # =================================================================
    # REMOTE MODE (per-repo)
    # =================================================================
    if not test -f "$remote_config"
        echo "Remote config not found: $remote_config"
        return 1
    end

    _devup_parse_repo_url $repo_url
    or return 1

    set -l owner $_parsed_owner
    set -l repo $_parsed_repo
    set -l clone_url $_parsed_clone_url
    set -l project "$owner/$repo"

    echo "==> Remote devcontainer: $project"

    set -l meta_dir "$HOME/.devcontainers/$owner/$repo"
    mkdir -p "$meta_dir"

    # Warn about unpushed dotfiles commits
    if test -d "$dotfiles_dir/.git"
        git -C "$dotfiles_dir" fetch origin master --quiet 2>/dev/null
        set -l unpushed (git -C "$dotfiles_dir" log origin/master..HEAD --oneline 2>/dev/null)
        if test -n "$unpushed"
            set_color yellow
            echo "  WARNING: dotfiles has unpushed commits (container will use GitHub master):"
            for line in $unpushed
                echo "    $line"
            end
            set_color normal

            if contains -- --remove-existing-container $extra_args
                read -P "  Continue with --remove-existing-container? (y/N) " -l confirm
                if not string match -qi y -- $confirm
                    echo "  Aborted."
                    return 1
                end
            end
        end
    end

    # DOCKER_HOST resolution (--local skips remote host)
    if test $force_local -eq 1
        set -g _docker_host_env ""
        set -g _docker_cmd docker
    else
        _resolve_docker_host $owner $repo $docker_host
    end
    if test -n "$docker_host"
        echo "  Docker host: $_docker_host_env"
    else if test -n "$_docker_host_env"
        echo "  Docker host (auto): $_docker_host_env"
    end

    # --sync mode
    if test $sync_mode -eq 1
        set -l cid ($_docker_cmd ps -q --filter "label=devcontainer.project=$project" 2>/dev/null)
        if test -z "$cid"
            echo "No running container found for $project"
            return 1
        end

        echo "==> Syncing dotfiles in container..."
        $_docker_cmd exec -u vscode $cid sh -c 'cd "$HOME/dotfiles" && git fetch origin && git reset --hard origin/master'
        or begin
            echo "  ERROR: git sync failed"
            return 1
        end

        echo "==> Re-running setup.sh..."
        $_docker_cmd exec -u vscode $cid sh -c 'bash "$HOME/dotfiles/.devcontainer/setup.sh"'
        or echo "  WARN: setup.sh had errors (non-fatal)"

        echo "==> Dotfiles synced!"
        return 0
    end

    # Volume name (unique per project)
    set -l volume_name "devcontainer-workspace-$owner-$repo"

    # Pull latest image
    set -l image "ghcr.io/skmtkytr/devcontainer:latest"
    set -l old_digest ($_docker_cmd image inspect $image --format '{{index .RepoDigests 0}}' 2>/dev/null)
    echo "==> Pulling latest image..."
    $_docker_cmd pull $image 2>&1
    set -l new_digest ($_docker_cmd image inspect $image --format '{{index .RepoDigests 0}}' 2>/dev/null)

    if test -n "$old_digest" -a -n "$new_digest" -a "$old_digest" != "$new_digest"
        set_color yellow
        echo "  Image updated! Consider: devup $project --remove-existing-container"
        set_color normal
    end

    # devcontainer up
    echo "==> Starting container..."
    set -l up_args \
        --config "$remote_config" \
        --id-label "devcontainer.project=$project" \
        --dotfiles-repository "https://github.com/skmtkytr/dotfiles.git" \
        --dotfiles-target-path "~/dotfiles" \
        --dotfiles-install-command ".devcontainer/setup.sh" \
        --workspace-folder "$dotfiles_dir"

    set -l up_tmpfile (mktemp /tmp/devup.XXXXXX)
    set -l env_args DEVCONTAINER_VOLUME_NAME=$volume_name
    if test -n "$_docker_host_env"
        set -a env_args DOCKER_HOST=$_docker_host_env
    end
    env $env_args devcontainer up $up_args $extra_args 2>&1 | tee $up_tmpfile
    set -l up_status $pipestatus[1]

    if test $up_status -ne 0
        rm -f $up_tmpfile
        echo "devcontainer up failed"
        return 1
    end

    set -l cid (string match -r '"containerId":"([^"]+)"' < $up_tmpfile | tail -1)
    rm -f $up_tmpfile
    if test -z "$cid"
        set cid ($_docker_cmd ps -q --filter "label=devcontainer.project=$project" 2>/dev/null)
    end
    if test -z "$cid"
        echo "Container not found after devcontainer up"
        return 1
    end

    $_docker_cmd update --restart unless-stopped $cid 2>/dev/null
    $_docker_cmd exec $cid chown vscode:vscode /workspace 2>/dev/null

    # Clone repo into /workspace if empty
    set -l ws_files ($_docker_cmd exec $cid ls -A /workspace 2>/dev/null | head -1)
    if test -z "$ws_files"
        echo "==> Cloning $clone_url into /workspace..."
        if not $_docker_cmd exec -u vscode $cid sh -c 'export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"; git clone '"$clone_url"' /workspace' 2>&1
            set -l gh_status ($_docker_cmd exec -u vscode $cid sh -c 'export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:/usr/local/bin:$PATH"; gh auth status' 2>&1)
            if string match -q '*not logged*' -- $gh_status; or string match -q '*no token*' -- $gh_status; or not string match -q '*Logged in*' -- $gh_status
                set_color yellow
                echo "  Clone failed: GitHub CLI is not authenticated in the container."
                echo ""
                echo "  Steps to fix:"
                echo "    1. devfish $project"
                echo "    2. gh auth login"
                echo "    3. git clone $clone_url /workspace"
                set_color normal
            else
                set_color yellow
                echo "  Clone failed: You may not have access to $clone_url"
                echo ""
                echo "  Check:"
                echo "    - Repository exists and you have read access"
                echo "    - devfish $project → gh auth status (verify scopes)"
                set_color normal
            end
        end
    end

    # Run mise install if .mise.toml exists
    set -l has_mise ($_docker_cmd exec $cid sh -c 'test -f /workspace/.mise.toml && echo yes' 2>/dev/null)
    if test "$has_mise" = yes
        echo "==> Running mise install..."
        $_docker_cmd exec -u vscode $cid sh -c 'cd /workspace && export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH" && mise install --yes' 2>&1
        or echo "  WARN: mise install had errors (non-fatal)"
    end

    # Save meta file
    set -l created_at (date -u +%Y-%m-%dT%H:%M:%SZ)
    set -l saved_host $_docker_host_env
    if test $force_local -eq 1
        set saved_host local
    end
    printf '%s\n' \
        "# devup meta – generated automatically" \
        "DOCKER_HOST=$saved_host" \
        "PROJECT=$project" \
        "CLONE_URL=$clone_url" \
        "VOLUME=$volume_name" \
        "CONTAINER_ID=$cid" \
        "CREATED_AT=$created_at" >"$meta_dir/.devup-meta"

    echo "==> Ready! Use:"
    echo "  devnvimserver $project"
    echo "  devfish $project"
end
