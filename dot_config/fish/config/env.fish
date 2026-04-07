# ===========================================================================
# Environment variables (single source of truth)
# XDG vars are defined in config.fish before this file is sourced.
# ===========================================================================

# locale
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# shell
set -x SHELL (which fish)

# ---------------------------------------------------------------------------
# XDG overrides for tools
# ---------------------------------------------------------------------------
set -gx DOCKER_CONFIG $XDG_CONFIG_HOME/docker
set -gx CARGO_HOME $XDG_DATA_HOME/cargo
set -gx RUSTUP_HOME $XDG_DATA_HOME/rustup
set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
set -gx NODE_REPL_HISTORY $XDG_DATA_HOME/node_repl_history
set -gx NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -gx LESSHISTFILE $XDG_STATE_HOME/less/history
set -gx WAKATIME_HOME $XDG_CONFIG_HOME/wakatime
set -gx PYTHON_HISTORY $XDG_STATE_HOME/python/history
set -gx AWS_CONFIG_FILE $XDG_CONFIG_HOME/aws/config
set -gx AWS_SHARED_CREDENTIALS_FILE $XDG_CONFIG_HOME/aws/credentials
set -gx GOPATH $XDG_DATA_HOME/go
set -gx GOCACHE $XDG_CACHE_HOME/go-build
set -gx GEM_HOME $XDG_DATA_HOME/gem
set -gx GEM_SPEC_CACHE $XDG_CACHE_HOME/gem
set -gx BUNDLE_USER_CONFIG $XDG_CONFIG_HOME/bundle
set -gx BUNDLE_USER_CACHE $XDG_CACHE_HOME/bundle
set -gx BUNDLE_USER_PLUGIN $XDG_DATA_HOME/bundle
set -gx SQLITE_HISTORY $XDG_CACHE_HOME/sqlite_history

# ---------------------------------------------------------------------------
# Homebrew (macOS)
# ---------------------------------------------------------------------------
set -gx HOMEBREW_BUNDLE_FILE $XDG_CONFIG_HOME/Brewfile
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM /opt/homebrew
set -gx HOMEBREW_X86_64 /usr/local
fish_add_path $HOMEBREW_ARM/bin
fish_add_path $HOMEBREW_X86_64/bin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/opt/binutils/bin
fish_add_path /opt/homebrew/opt/llvm/bin

# ---------------------------------------------------------------------------
# PATH additions
# ---------------------------------------------------------------------------
fish_add_path /usr/local/bin
fish_add_path /usr/local
fish_add_path /var/lib/snapd/snap/bin

# XDG tool bins
fish_add_path $CARGO_HOME/bin
fish_add_path $GOPATH/bin

# user local bin
fish_add_path ~/.local/bin

# mise shims (needed before cache generation so starship/zoxide are found)
fish_add_path ~/.local/share/mise/shims

# ---------------------------------------------------------------------------
# Editors
# ---------------------------------------------------------------------------
if type -q nvim
    set -gx EDITOR nvim
    set -gx GIT_EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim -c ASMANPAGER -"
end

# ---------------------------------------------------------------------------
# SSH (1Password agent)
# ---------------------------------------------------------------------------
# On macOS host: use 1Password agent symlink directly.
# In containers: SSH_AUTH_SOCK is set by conf.d/host-shared-env.fish
# (socat bridge). Don't override it.
if not set -q container; and not test -f /.dockerenv
    set -gx SSH_AUTH_SOCK $HOME/.ssh/agent.sock
end

# ---------------------------------------------------------------------------
# Theme
# ---------------------------------------------------------------------------
set -gx theme_nerd_fonts yes
set -gx BIT_THEME monochrome

# ---------------------------------------------------------------------------
# ni (package manager runner)
# ---------------------------------------------------------------------------
set -g NA_PACKAGE_MANAGER_LIST bun deno pnpm npm yarn mise
set -g NA_FUZZYFINDER_OPTIONS --bind 'one:accept' --query '^'
