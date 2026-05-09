# Cache PWD per zellij pane so save-sessions.sh can inject cwd= even after
# fish processes are killed at logout. At logout, foot-server.service stops
# concurrently with zellij-save-session.service (both After=graphical-session
# .target with no ordering between them); foot's cgroup SIGTERM kills fish/
# zellij before the script reads /proc/PID/cwd. The cache file persists.

if not set -q ZELLIJ_PANE_ID
    exit 0
end

set -l _zpc_dir $XDG_CACHE_HOME/zellij/pane-cwd
set -l _zpc_key "$ZELLIJ_SESSION_NAME-$ZELLIJ_PANE_ID"

function __zellij_pane_cwd_write --on-variable PWD --inherit-variable _zpc_dir --inherit-variable _zpc_key
    mkdir -p $_zpc_dir 2>/dev/null
    echo $PWD >$_zpc_dir/$_zpc_key 2>/dev/null
end

# Initial write (PWD is set before conf.d sourcing)
mkdir -p $_zpc_dir 2>/dev/null
echo $PWD >$_zpc_dir/$_zpc_key 2>/dev/null
