function _detect_project_from_cwd --description "Detect owner/repo from ghq cwd"
    # Sets: _detected_project (e.g. "owner/repo") or empty string
    set -g _detected_project ""
    set -l ghq_root (ghq root 2>/dev/null)
    if test -n "$ghq_root"
        set -l rel (string replace "$ghq_root/" "" -- (pwd))
        if string match -qr '^[^/]+/([^/]+/[^/]+)' -- $rel
            set -g _detected_project (string match -r '^[^/]+/([^/]+/[^/]+)' -- $rel)[2]
        end
    end
end
