# Expose mise-installed tools' man pages to MANPATH.
#
# mise does not export MANPATH, so without this the man pages under
# ~/.local/share/mise/installs are invisible: `man node` would fall back to a
# system version (or fail), and fish can't generate completions from them.
#
# This only sets MANPATH. Refreshing fish's man-derived completions is a manual
# `fish_update_completions` (fish does not do it automatically) — done rarely,
# after installing a man-equipped tool whose completion you actually want. We
# deliberately do NOT auto-run it on a hook: it rewrites thousands of files,
# prints progress over the prompt, and only a couple of tools (node, java)
# benefit. carapace covers the man-less tools dynamically instead.

status is-interactive; or return

set -l mise_installs $HOME/.local/share/mise/installs
test -d $mise_installs; or return

# path resolve collapses the symlinked version aliases (25, 25.6, latest ->
# 25.6.1); the trailing "" element keeps the system default manpath appended.
set -l mandirs (path resolve \
    $mise_installs/*/*/share/man \
    $mise_installs/*/*/man \
    $mise_installs/*/*/*/share/man 2>/dev/null | sort -u)
if set -q mandirs[1]
    set -gx --path MANPATH $mandirs ""
end
