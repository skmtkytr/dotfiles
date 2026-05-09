#!/bin/sh
# Save all active zellij sessions and inject cwd= per pane so resurrect
# starts panes in the right directory.
#
# Why injection is needed (zellij v0.44.1 source confirmed):
#  - zellij serializes the foreground program's cwd via /proc at save time.
#    For a fish-spawned `claude`, the saved cwd is claude's launch-time cwd,
#    which can differ from where fish currently is.
#  - All-pane common cwd prefix is hoisted to top-level `layout { cwd ... }`
#    (session_layout_metadata.rs:306-315), so individual panes often have
#    no `cwd=` and inherit the global one — losing per-pane location.
#  - `contents_file=` is never written for `command=` panes
#    (session_serialization.rs:313-321) — scrollback restore is shell-only.
#
# Why we cache fish PWD ourselves:
#  - At logout, foot-server.service stops at the same second as this unit
#    (both After=graphical-session.target, no mutual ordering). foot's cgroup
#    SIGTERM kills fish before /proc/PID/cwd can be read.
#  - The fish hook (conf.d/zellij-pane-cwd.fish) writes PWD to a cache file
#    per pane on every `cd`. The file survives fish's death.

set -u

LOG="${HOME}/.cache/zellij/save-sessions.log"
log() { printf '%s %s\n' "$(date -Is)" "$*" >>"$LOG"; }

# 1. Use the same zellij binary as the running server. cargo and mise installs
#    can diverge in version (e.g. cargo 0.45.0 vs mise 0.44.1) and IPC may
#    fail across versions.
SERVER_PID="$(pgrep -u "$(id -u)" -f 'zellij.*--server' 2>/dev/null | head -1)"
if [ -n "$SERVER_PID" ] && [ -r "/proc/$SERVER_PID/exe" ]; then
    ZELLIJ="$(readlink "/proc/$SERVER_PID/exe" 2>/dev/null)"
fi
[ -n "${ZELLIJ:-}" ] && [ -x "$ZELLIJ" ] || ZELLIJ="${HOME}/.local/share/cargo/bin/zellij"

log "=== start (zellij=$ZELLIJ server_pid=${SERVER_PID:-none}) ==="

[ -x "$ZELLIJ" ] || { log "zellij not executable, exit"; exit 0; }

# 2. Trigger live save while the server is still up.
sessions="$("$ZELLIJ" list-sessions -s 2>/dev/null)"
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

# 3. Freeze the layout. Without this, a later SIGTERM (foot stopping after us)
#    re-serializes with dying panes and overwrites the good layout.
if pkill -KILL -f 'zellij.*--server' 2>/dev/null; then
    log "killed zellij-server (layout frozen)"
    sleep 0.2
else
    log "zellij-server not running"
fi

# 4. Inject cwd= per pane into every saved session-layout.kdl.
CACHE_DIR="${HOME}/.cache/zellij/pane-cwd"
SESSION_INFO_DIR="${HOME}/.cache/zellij/contract_version_1/session_info"

for layout in "$SESSION_INFO_DIR"/*/session-layout.kdl; do
    [ -f "$layout" ] || continue
    session_dir="${layout%/session-layout.kdl}"
    session="${session_dir##*/}"

    # Build CWDS: cache file (preferred) → /proc fallback. Order: ascending
    # pane_id. Pane lines in the layout are written in the same order.
    cwds=""
    if [ -d "$CACHE_DIR" ]; then
        for f in $(ls "$CACHE_DIR" 2>/dev/null | grep "^${session}-" | sort -t- -k2 -n); do
            content="$(head -1 "$CACHE_DIR/$f" 2>/dev/null)"
            [ -n "$content" ] && cwds="${cwds}${content}
"
        done
    fi
    if [ -z "$cwds" ]; then
        # Fallback: scrape live fish processes (only useful pre-logout)
        for pid in $(pgrep -u "$(id -u)" fish 2>/dev/null | sort -n); do
            env="$(tr '\0' '\n' </proc/"$pid"/environ 2>/dev/null)"
            if printf '%s' "$env" | grep -q "^ZELLIJ_SESSION_NAME=${session}\$"; then
                pid_cwd="$(readlink /proc/"$pid"/cwd 2>/dev/null || true)"
                [ -n "$pid_cwd" ] && cwds="${cwds}${pid_cwd}
"
            fi
        done
    fi

    export CWDS="$cwds"
    log "$layout: cwds=$(printf '%s' "$cwds" | tr '\n' '|')"

    HOME="$HOME" perl -i -e '
        use strict;
        my @cwds = length($ENV{CWDS}) ? split(/\n/, $ENV{CWDS}) : ();
        my $home = $ENV{HOME} // "";
        my $idx = 0;
        my ($injected, $skipped) = (0, 0);
        while (my $line = <>) {
            # Match terminal pane lines we want to inject cwd= into.
            # Skip:
            #  - pane that already has cwd=
            #  - status bar pane (size=1 borderless=true ... { plugin ... })
            #  - tab/floating_panes/swap_*_layout container lines
            if ($line =~ /^\s+pane\b/
                && $line !~ /\bcwd=/
                && $line !~ /^\s+pane size=1\b/
                && ($line =~ /\bcommand=/ || $line =~ /\bcontents_file=/)) {
                my $cwd = $cwds[$idx] // "";
                $cwd =~ s/^\s+|\s+$//g;
                if ($cwd && $cwd ne $home && -d $cwd) {
                    (my $safe = $cwd) =~ s/"/\\"/g;
                    $line =~ s/^(\s+pane )/$1cwd="$safe" /;
                    $injected++;
                } else {
                    $skipped++;
                }
                $idx++;
            }
            print $line;
        }
        print STDERR "injected=$injected skipped=$skipped panes_seen=$idx\n";
    ' "$layout" 2>>"$LOG"
done
log "=== end ==="
