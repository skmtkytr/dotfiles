#!/usr/bin/env bash
# devcontainer postCreate / on-demand bootstrap.
#
# Invoked by host-side `devup` after `devcontainer up`. Idempotent.
#
# Assumes:
#   - Bind mount: $HOST_HOME/.local/share/chezmoi → ~/.local/share/chezmoi
#   - Bind mount: $HOST_HOME/.ghq → ~/.ghq
#   - Named volumes: ~/.local/share/{mise,nvim,fish,tmux}
#   - chezmoi binary at /usr/local/bin/chezmoi (installed by Dockerfile)
#   - --network=host so 127.0.0.1 reaches host's localhost (1Password TCP bridge)

set -euo pipefail

DOTFILES_SOURCE="$HOME/.local/share/chezmoi"

echo "==> dotfiles devcontainer setup (chezmoi-native)"

# -------------------------------------------------------------------
# 1. Fix ownership of named volumes (created as root by docker)
#
# Docker also creates the parent dirs (~/.local, ~/.local/share) as root
# when mounting volumes underneath, so vscode can't create siblings like
# ~/.local/share/uv. Chown those parents non-recursively first.
# -------------------------------------------------------------------
for parent in ~/.local ~/.local/share
do
    if [ -d "$parent" ]; then
        sudo chown "$(id -u):$(id -g)" "$parent" 2>/dev/null \
            && echo "  fixed ownership: $parent"
    fi
done

for vol_dir in \
    ~/.local/share/mise \
    ~/.local/share/nvim \
    ~/.local/share/fish \
    ~/.local/share/tmux \
    ~/.claude
do
    if [ -d "$vol_dir" ]; then
        sudo chown -R "$(id -u):$(id -g)" "$vol_dir" 2>/dev/null \
            && echo "  fixed ownership: $vol_dir"
    fi
done

# -------------------------------------------------------------------
# 2. Container chezmoi config: source dir + feature overrides
# -------------------------------------------------------------------
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" << EOF
sourceDir = "$DOTFILES_SOURCE"

[data]
    [data.git]
    name = "Kyotaro Sakamoto / skmtkytr"
    email = "skmtkytr+github@gmail.com"

    [data.github]
    user = "skmtkytr"

    [data.features]
    secrets_available = false
    in_devcontainer = true

    [data.alacritty]
    fontSize = 12
EOF
echo "  wrote chezmoi.toml"

# -------------------------------------------------------------------
# 3. SSH agent bridge helper
#
# devup.fish on the host runs:
#   socat TCP-LISTEN:12345,bind=127.0.0.1 UNIX-CONNECT:~/.ssh/agent.sock
# This script (run from fish conf.d on every shell start) hooks
# the container's UNIX socket to that TCP bridge.
# -------------------------------------------------------------------
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/ssh-agent-bridge.sh" << 'BRIDGESH'
#!/bin/bash
SOCK="$HOME/.ssh/ssh-agent-bridge.sock"
mkdir -p "$(dirname "$SOCK")"

if [ -S "$SOCK" ] && pgrep -f "socat.*UNIX-LISTEN:$SOCK" >/dev/null 2>&1; then
    exit 0
fi

rm -f "$SOCK"
if command -v socat >/dev/null 2>&1; then
    nohup socat UNIX-LISTEN:"$SOCK",fork,mode=600 TCP:127.0.0.1:12345 \
        >/dev/null 2>&1 &
    for _ in $(seq 10); do
        [ -S "$SOCK" ] && exit 0
        sleep 0.1
    done
fi
BRIDGESH
chmod +x "$HOME/.local/bin/ssh-agent-bridge.sh"
echo "  installed ssh-agent-bridge helper"

# -------------------------------------------------------------------
# 3b. GitHub host key + gh auth (uses GITHUB_TOKEN from host)
# -------------------------------------------------------------------
echo "==> configuring GitHub auth"

# SSH known_hosts for github.com
mkdir -p "$HOME/.ssh"
ssh-keyscan -t ed25519,rsa github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null \
    && echo "  added github.com to known_hosts"

# gh CLI auth via GITHUB_TOKEN (passed from host's `gh auth token`)
if [ -n "${GITHUB_TOKEN:-}" ]; then
    echo "$GITHUB_TOKEN" | gh auth login --with-token 2>/dev/null \
        && echo "  gh auth: logged in via GITHUB_TOKEN"
    gh auth setup-git 2>/dev/null \
        && echo "  gh auth: configured git credential helper"
fi

# -------------------------------------------------------------------
# 4. chezmoi apply — deploys all dot_config files into ~/.config etc.
# --force: non-interactive overwrite of any drift (no TTY here)
# -------------------------------------------------------------------
echo "==> chezmoi apply"
chezmoi apply --no-tty --force

# -------------------------------------------------------------------
# 5. mise install — base tools + devcontainer extras
# -------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
if command -v mise >/dev/null 2>&1; then
    echo "==> mise install (base tools)"
    mise install -y \
        || echo "  WARN: mise install had errors (non-fatal)"
    if [ -f "$HOME/.config/mise/config.devcontainer.toml" ]; then
        echo "==> mise install (devcontainer extras)"
        mise install --file "$HOME/.config/mise/config.devcontainer.toml" -y \
            || echo "  WARN: mise install had errors (non-fatal)"
    fi
fi

# -------------------------------------------------------------------
# 6. tmux tpm — volume gets emptied on each fresh container, so install
# -------------------------------------------------------------------
TPM_DIR="$HOME/.local/share/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "==> installing tpm"
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR" \
        2>&1 | tail -3 || true
fi
if [ -x "$TPM_DIR/bin/install_plugins" ]; then
    timeout 60 "$TPM_DIR/bin/install_plugins" 2>&1 | tail -5 || true
fi

# -------------------------------------------------------------------
# 7. nvim Lazy sync — populate the nvim data volume
# -------------------------------------------------------------------
echo "==> nvim Lazy sync"
timeout 300 nvim --headless "+Lazy! sync" +qa 2>&1 | tail -10 || true

# -------------------------------------------------------------------
# 8. Clear fish config cache so starship/zoxide init regenerate
# -------------------------------------------------------------------
rm -f "$HOME/.cache/fish/config.fish"

echo "==> setup complete"
