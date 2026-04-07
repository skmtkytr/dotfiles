function _ensure_commands_exist --description "Check required commands exist"
    for cmd in $argv
        if not type -q $cmd
            echo "Required command '$cmd' not found. Please install it and try again." >&2
            return 1
        end
    end
end
