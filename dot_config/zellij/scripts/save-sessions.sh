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
        # Track brace depth + whether we are inside a top-level `tab` block.
        # cwds[] is keyed by pane_id order across the running session, so it
        # should be matched only against panes that appear in real tabs —
        # ignore template/swap_tiled_layout `pane` declarations entirely.
        my $cur_depth = 0;
        my $in_top_tab = 0;
        my $tab_indent = "";
        while (my $line = <>) {
            if ($cur_depth == 1 && $line =~ /^(\s+)tab\b.*\{\s*$/) {
                $in_top_tab = 1;
                $tab_indent = $1;
            }
            # Within a top-level tab, every non-status-bar `pane` line
            # consumes one cwds[] slot — whether or not we inject — so the
            # index stays aligned even when zellij already wrote `cwd=`.
            # Inject when the pane has no `cwd=` of its own; otherwise it
            # falls back to the layout-level cwd at resurrect, which is the
            # common prefix of all panes and almost always wrong for any
            # pane that lived in a deeper directory at save time. This
            # covers both bare `pane` lines (zellij emits these for panes
            # whose cwd matched the common prefix exactly, or when no
            # scrollback was serialized) and `pane command=…` /
            # `pane contents_file=…` lines.
            if ($in_top_tab
                && $line =~ /^\s+pane\b/
                && $line !~ /^\s+pane size=1\b/) {
                if ($line !~ /\bcwd=/) {
                    my $cwd = $cwds[$idx] // "";
                    $cwd =~ s/^\s+|\s+$//g;
                    if ($cwd && $cwd ne $home && -d $cwd) {
                        (my $safe = $cwd) =~ s/"/\\"/g;
                        # `\b` after `pane` so we match both `pane\n`
                        # (bare) and `pane command=…` (suffixed).
                        $line =~ s/^(\s+pane)\b/$1 cwd="$safe"/;
                        $injected++;
                    } else {
                        $skipped++;
                    }
                }
                $idx++;
            }
            print $line;
            $cur_depth += () = $line =~ /\{/g;
            $cur_depth -= () = $line =~ /\}/g;
            if ($in_top_tab && $cur_depth == 1 && $line =~ /^\Q$tab_indent\E\}\s*$/) {
                $in_top_tab = 0;
            }
        }
        print STDERR "injected=$injected skipped=$skipped panes_seen=$idx\n";
    ' "$layout" 2>>"$LOG"

    # 5. Restore zjstatus plugin config block. zellij'\''s serialize drops the
    #    plugin block'\''s config children (only the location is preserved); on
    #    next resurrect zjstatus shows "No configuration found". The config
    #    only lives in default.kdl'\''s default_tab_template, so we copy it
    #    over every `pane size=1 borderless=true { plugin ...zjstatus... }`
    #    block in the saved layout.
    DEFAULT_KDL="${HOME}/.config/zellij/layouts/default.kdl"
    if [ -f "$DEFAULT_KDL" ]; then
        # NOTE: do NOT use `perl -i` here. The output is built into @out and
        # written after the input loop ends — and `perl -i`'\''s STDOUT
        # redirection to the input file is deactivated as soon as <> exhausts.
        # `print @out` after that point would go to script STDOUT (journald
        # under systemd), and the file would be left truncated to 0 bytes.
        # Use explicit open/read, then open/write to avoid the trap.
        DEFAULT_KDL="$DEFAULT_KDL" LAYOUT="$layout" perl -e '
            use strict;
            # 1. Extract canonical pane block from default.kdl.
            open my $fh, "<", $ENV{DEFAULT_KDL} or die $!;
            my @canon_lines;
            my ($in_block, $depth, $is_zjstatus) = (0, 0, 0);
            while (my $line = <$fh>) {
                if (!$in_block) {
                    if ($line =~ /^(\s*)pane size=1 borderless=true \{/) {
                        @canon_lines = ($line);
                        $in_block = 1;
                        $depth = 1;
                        $is_zjstatus = 0;
                    }
                    next;
                }
                push @canon_lines, $line;
                $is_zjstatus = 1 if $line =~ /plugin location="(?:zjstatus|file:[^"]*zjstatus\.wasm)"/;
                $depth += () = $line =~ /\{/g;
                $depth -= () = $line =~ /\}/g;
                if ($depth <= 0) {
                    last if $is_zjstatus;
                    $in_block = 0;
                    @canon_lines = ();
                }
            }
            close $fh;

            # Read layout file fully before reopening for write.
            open my $in, "<", $ENV{LAYOUT} or die $!;
            my @lines = <$in>;
            close $in;

            unless ($is_zjstatus && @canon_lines) {
                # No canonical block found — pass through unchanged.
                open my $out_fh, ">", $ENV{LAYOUT} or die $!;
                print $out_fh @lines;
                close $out_fh;
                exit 0;
            }
            # Strip leading horizontal whitespace (will re-indent per call site).
            # Use [ \t] not \s — \s includes newlines and would eat blank lines.
            my $canon_indent = ($canon_lines[0] =~ /^([ \t]*)/) ? length($1) : 0;
            my @canon_stripped;
            for my $l (@canon_lines) {
                my $stripped = $l;
                $stripped =~ s/^[ \t]{0,$canon_indent}//;
                push @canon_stripped, $stripped;
            }

            # 2. Process layout: replace any pane block with zjstatus plugin
            #    inside it with the canonical version (re-indented).
            my @out;
            my @buf;
            my ($in_pane, $pane_depth, $pane_indent, $buf_is_zjstatus) = (0, 0, "", 0);
            my $replaced = 0;
            for my $line (@lines) {
                if (!$in_pane) {
                    if ($line =~ /^(\s*)pane size=1 borderless=true \{/) {
                        @buf = ($line);
                        $in_pane = 1;
                        $pane_depth = 1;
                        $pane_indent = $1;
                        $buf_is_zjstatus = 0;
                    } else {
                        push @out, $line;
                    }
                    next;
                }
                push @buf, $line;
                $buf_is_zjstatus = 1 if $line =~ /plugin location="(?:zjstatus|file:[^"]*zjstatus\.wasm)"/;
                $pane_depth += () = $line =~ /\{/g;
                $pane_depth -= () = $line =~ /\}/g;
                if ($pane_depth <= 0) {
                    if ($buf_is_zjstatus) {
                        for my $cl (@canon_stripped) {
                            # Don'\''t indent blank/whitespace-only lines.
                            push @out, ($cl =~ /^\s*$/) ? $cl : ($pane_indent . $cl);
                        }
                        $replaced++;
                    } else {
                        push @out, @buf;
                    }
                    @buf = ();
                    $in_pane = 0;
                }
            }
            # Trailing partial buffer (malformed layout — emit as-is).
            push @out, @buf if @buf;

            open my $out_fh, ">", $ENV{LAYOUT} or die $!;
            print $out_fh @out;
            close $out_fh;
            print STDERR "zjstatus_blocks_restored=$replaced\n";
        ' 2>>"$LOG"

        # 6. Inject default_tab_template into the saved layout so every tab
        #    gets wrapped with zjstatus on resurrect — even tabs whose runtime
        #    state lost the zjstatus pane (e.g. plugin pane removed mid-
        #    session, command panes from held processes that bypass templates).
        #    default_tab_template lives only in default.kdl; zellij'\''s
        #    save-session never emits it. Without it, resurrection applies
        #    each tab'\''s explicit panes verbatim and any tab missing
        #    zjstatus in its serialized form stays missing.
        DEFAULT_KDL="$DEFAULT_KDL" LAYOUT="$layout" perl -e '
            use strict;
            # Extract default_tab_template block from default.kdl.
            open my $fh, "<", $ENV{DEFAULT_KDL} or die $!;
            my @template_lines;
            my ($in_block, $depth) = (0, 0);
            while (my $line = <$fh>) {
                if (!$in_block) {
                    if ($line =~ /^(\s*)default_tab_template\s*\{/) {
                        @template_lines = ($line);
                        $in_block = 1;
                        $depth = 1;
                    }
                    next;
                }
                push @template_lines, $line;
                $depth += () = $line =~ /\{/g;
                $depth -= () = $line =~ /\}/g;
                last if $depth <= 0;
            }
            close $fh;
            exit 0 unless @template_lines;

            open my $in, "<", $ENV{LAYOUT} or die $!;
            my @lines = <$in>;
            close $in;

            # Skip if the saved layout already has a default_tab_template.
            if (grep { /^\s*default_tab_template\s*\{/ } @lines) {
                print STDERR "default_tab_template already present, skipping inject\n";
                exit 0;
            }

            # Find indent of layout body (first non-blank line after `layout {`).
            my $body_indent = "    ";
            for my $l (@lines) {
                next if $l =~ /^\s*layout\s*\{/;
                if ($l =~ /^(\s+)\S/) { $body_indent = $1; last; }
            }

            # Re-indent template lines to match layout body.
            my $template_indent = ($template_lines[0] =~ /^(\s*)/) ? $1 : "";
            my @reindented;
            for my $tl (@template_lines) {
                my $stripped = $tl;
                $stripped =~ s/^\Q$template_indent\E//;
                push @reindented, ($stripped =~ /^\s*$/) ? $stripped : ($body_indent . $stripped);
            }

            # Insert template after `layout {` (and any top-level `cwd "..."` line).
            my @out;
            my $inserted = 0;
            my $past_layout_open = 0;
            for my $line (@lines) {
                push @out, $line;
                if (!$inserted) {
                    if (!$past_layout_open && $line =~ /^\s*layout\s*\{/) {
                        $past_layout_open = 1;
                        next;
                    }
                    if ($past_layout_open) {
                        # Skip `cwd "..."` lines to keep them above the template.
                        next if $line =~ /^\s*cwd\s+"/;
                        # We are about to emit the first non-cwd body line — go
                        # back one step: insert template before this line.
                        my $last = pop @out;
                        push @out, @reindented;
                        push @out, $last;
                        $inserted = 1;
                    }
                }
            }
            unless ($inserted) {
                # Edge case: layout body is empty. Append before the final `}`.
                my $closing_idx;
                for (my $i = $#out; $i >= 0; $i--) {
                    if ($out[$i] =~ /^\s*\}\s*$/) { $closing_idx = $i; last; }
                }
                if (defined $closing_idx) {
                    splice @out, $closing_idx, 0, @reindented;
                    $inserted = 1;
                }
            }

            # Strip inline zjstatus pane blocks from top-level tabs to avoid
            # double-rendering: the template now provides one and any inline
            # block would stack a second `pane size=1` next to it.
            my @stripped;
            my $cur_depth = 0;
            my $in_top_tab = 0;
            my $tab_indent = "";
            my $i = 0;
            my $removed = 0;
            while ($i < @out) {
                my $line = $out[$i];
                # Track top-level tab entry/exit. Capture indent and check
                # `{` end in one regex — two separate `=~` matches reset $1
                # via the second non-capturing match, which would leave
                # $tab_indent empty and prevent the EXIT below from firing.
                if ($cur_depth == 1 && $line =~ /^(\s+)tab\b.*\{\s*$/) {
                    $in_top_tab = 1;
                    $tab_indent = $1;
                }
                # Detect inline zjstatus inside a top-level tab.
                if ($in_top_tab && $line =~ /^\s+pane size=1 borderless=true \{\s*$/) {
                    my $pane_start = $i;
                    my $pane_depth = 1;
                    my @buf = ($line);
                    my $j = $i + 1;
                    while ($j < @out && $pane_depth > 0) {
                        push @buf, $out[$j];
                        $pane_depth += () = $out[$j] =~ /\{/g;
                        $pane_depth -= () = $out[$j] =~ /\}/g;
                        $j++;
                    }
                    my $is_zjstatus = grep {
                        /plugin location="(?:zjstatus|file:[^"]*zjstatus\.wasm)"/
                    } @buf;
                    if ($is_zjstatus) {
                        $removed++;
                        $i = $j;
                        next;
                    }
                }
                push @stripped, $line;
                $cur_depth += () = $line =~ /\{/g;
                $cur_depth -= () = $line =~ /\}/g;
                # Exit top-level tab when its closing `}` is processed.
                if ($in_top_tab && $cur_depth == 1 && $line =~ /^\Q$tab_indent\E\}\s*$/) {
                    $in_top_tab = 0;
                }
                $i++;
            }

            open my $out_fh, ">", $ENV{LAYOUT} or die $!;
            print $out_fh @stripped;
            close $out_fh;
            print STDERR "default_tab_template_injected=$inserted inline_zjstatus_stripped=$removed\n";
        ' 2>>"$LOG"
    fi
done
log "=== end ==="
