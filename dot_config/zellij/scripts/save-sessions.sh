#!/bin/sh
# Save all active zellij sessions + inject `command="$SHELL"` and cwd= into
# bare panes so resurrect actually respawns shells. See upstream #4129/#4488.
#
# Resilient to zellij-server dying before us (systemd stop-order cycle).
# We get fish process cwds from /proc before anything dies, then inject into
# the last-saved layout regardless of zellij's liveness.

set -u
ZELLIJ="${HOME}/.local/share/cargo/bin/zellij"
export SHELL_CMD="$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7)"
SHELL_CMD="${SHELL_CMD:-/bin/sh}"

LOG="${HOME}/.cache/zellij/save-sessions.log"
log() { printf '%s %s\n' "$(date -Is)" "$*" >> "$LOG"; }
log "=== start (shell=$SHELL_CMD zellij=$ZELLIJ) ==="

[ -x "$ZELLIJ" ] || { log "zellij not executable, exit"; exit 0; }

# 1. Collect fish process cwds from /proc NOW — before anything dies.
#    Filter to zellij-internal fish processes via ZELLIJ= in their environ.
#    Sort by PID (creation order) to match layout pane order.
collect_fish_cwds() {
    for pid in $(pgrep -u "$(id -u)" fish 2>/dev/null | sort -n); do
        if tr '\0' '\n' < /proc/"$pid"/environ 2>/dev/null | grep -q '^ZELLIJ='; then
            readlink /proc/"$pid"/cwd 2>/dev/null || true
        fi
    done
}
export FISH_CWDS
FISH_CWDS="$(collect_fish_cwds)"
log "fish cwds from /proc: $(printf '%s' "$FISH_CWDS" | tr '\n' '|')"

# 2. Flush live state if zellij is still running.
sessions=$("$ZELLIJ" list-sessions -s 2>/dev/null)
if [ -n "$sessions" ]; then
    log "sessions: $(echo "$sessions" | tr '\n' ',')"
    for s in $sessions; do
        if "$ZELLIJ" --session "$s" action save-session 2>>"$LOG"; then
            log "save-session $s OK"
        else
            log "save-session $s FAILED"
        fi
    done
else
    log "no live sessions (zellij already dead?) — injecting from last auto-save"
fi

# 3. Freeze layout: kill zellij-server so no subsequent auto-serialize or
#    SIGTERM-triggered serialize overwrites our injected layout. We always
#    do this — the graphical-session.target is-active check was unreliable
#    (the target reports "active" until ALL its PartOf units have stopped,
#    so it's always "active" when our ExecStop runs). Without the kill, foot
#    stopping later sends SIGTERM to zellij, which re-serializes with any
#    panes that died from foot closing, overwriting our good layout.
if pkill -KILL -f 'zellij.*--server' 2>/dev/null; then
    log "killed zellij-server (layout frozen)"
    sleep 0.2
else
    log "zellij-server not running (already dead or not started)"
fi

# 4. Inject command= and cwd= into bare shell panes in every saved layout.
#    Uses a single perl pass that:
#      a) adds command="$SHELL_CMD" to panes with contents_file= but no command=
#      b) adds cwd= from the /proc-collected fish cwds (N-th bare pane → N-th
#         fish PID by creation order) when the layout has no cwd for that pane
for f in "${HOME}"/.cache/zellij/contract_version_1/session_info/*/session-layout.kdl; do
    [ -f "$f" ] || continue
    before=$(grep -c 'pane contents_file=' "$f" 2>/dev/null; :)
    HOME="${HOME}" perl -i -e '
        use strict;
        my @cwds = length($ENV{FISH_CWDS}) ? split /\n/, $ENV{FISH_CWDS} : ();
        my $home  = $ENV{HOME}     // "";
        my $shell = $ENV{SHELL_CMD} // "/bin/sh";
        my $idx   = 0;
        while (my $line = <>) {
            if ($line =~ /^\s+pane (?!command=)[^{}\n]*contents_file=/) {
                my $had_cwd = ($line =~ /cwd=/);
                # inject command=
                $line =~ s|^(\s+pane )(?!command=)([^{}\n]*contents_file=)|${1}command="$shell" ${2}|;
                # inject cwd= from /proc if not already in layout
                if (!$had_cwd) {
                    my $cwd = $cwds[$idx] // "";
                    $cwd =~ s/^\s+|\s+$//g;
                    if ($cwd && $cwd ne $home && -d $cwd) {
                        (my $safe = $cwd) =~ s/"/\\"/g;
                        $line =~ s/(^\s+pane )/$1cwd="$safe" /;
                    }
                }
                $idx++;
            }
            print $line;
        }
    ' "$f"
    after=$(grep -c 'pane contents_file=' "$f" 2>/dev/null; :)
    log "$f: contents_file-only panes $before -> $after (injected $((before - after)))"
done
log "=== end ==="
