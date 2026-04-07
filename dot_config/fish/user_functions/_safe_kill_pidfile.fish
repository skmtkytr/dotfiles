function _safe_kill_pidfile --description "Kill process/group from pidfile and remove it"
    set -l pid_file $argv[1]
    if test -f "$pid_file"
        set -l old_pid (cat "$pid_file" 2>/dev/null)
        if test -n "$old_pid"
            kill -- -$old_pid 2>/dev/null || true
            kill $old_pid 2>/dev/null || true
        end
        rm -f "$pid_file" 2>/dev/null || true
    end
end
