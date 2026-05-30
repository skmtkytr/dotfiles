# Dynamic completion for gws (Google Workspace CLI).
#
# gws is a hand-rolled CLI: no completion framework, no man page, and not
# covered by carapace, so nothing can generate a static completion for it.
# But each level is introspectable -- `gws <path...> --help` prints a
# "Commands:" (sub-levels) or "SERVICES:" (top level) block and never executes
# the request -- so we parse that into candidates at completion time. This
# tracks whatever version of gws is installed.

function __gws_subcommands
    set -l tokens (commandline -xpc)
    set -e tokens[1] # drop "gws"
    # Follow only the leading subcommand chain; stop at the first flag so we
    # don't feed option values (e.g. --params '{...}') into the help probe.
    set -l path
    for t in $tokens
        string match -q -- '-*' $t; and break
        set -a path $t
    end
    command gws $path --help 2>&1 | awk '
        /^(Commands|SERVICES):/ { incmd = 1; next }
        /^[A-Za-z].*:[ \t]*$/   { incmd = 0 }
        incmd && /^[[:space:]]+[^[:space:]]/ {
            name = $1
            if (name == "help") next
            $1 = ""; sub(/^[[:space:]]+/, "")
            print name "\t" $0
        }'
end

complete -c gws -f -a '(__gws_subcommands)'
