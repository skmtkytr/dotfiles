function _ensure_pid_dir --description "Ensure pid file directory exists and writable"
    set -l pid_file $argv[1]
    if test -z "$pid_file"
        return 0
    end
    set -l dir (dirname "$pid_file")
    if not test -d "$dir"
        mkdir -p "$dir" 2>/dev/null
        or begin
            echo "Cannot create pid dir: $dir" >&2
            return 1
        end
    end
    if not test -w "$dir"
        echo "Pid directory not writable: $dir" >&2
        return 1
    end
end
