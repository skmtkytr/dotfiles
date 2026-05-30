# Universal completion engine for CLIs that ship no native fish completion
# (bun, go, docker, ...). This is the category fix for the "man-less tool ->
# no completion" gap that fish's man-page generation can't cover.
#
# Note: carapace runs `complete -e` before registering its own, so for every
# command it knows it REPLACES fish's native completion. Native completions
# survive only for commands carapace does not cover.

status is-interactive; or return

# Init via the absolute shim path: conf.d runs before config.fish puts the mise
# shims on PATH, so a bare `carapace` may not resolve yet here. At completion
# time (post-startup) PATH is ready, so the bare `carapace` inside the
# generated completer functions works fine.
set -l carapace_bin $HOME/.local/share/mise/shims/carapace
test -x $carapace_bin; or return
$carapace_bin _carapace fish | source
