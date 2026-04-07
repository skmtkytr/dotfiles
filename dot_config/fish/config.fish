# ###############
# # fish config
# ###############
########################################

# define XDG paths (must come before everything else)
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME || set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache
if not set -q XDG_RUNTIME_DIR
    set -gx XDG_RUNTIME_DIR /tmp/(id -u)-runtime-dir
    if not test -d $XDG_RUNTIME_DIR
        mkdir $XDG_RUNTIME_DIR
        chmod 0700 $XDG_RUNTIME_DIR
    end
end

# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR $XDG_CACHE_HOME/fish

# add user config (custom functions/completions separate from fisher-managed dirs)
set -gp fish_function_path $FISH_CONFIG_DIR/user_functions
set -gp fish_complete_path $FISH_CONFIG_DIR/user_completions

# source config/*.fish (env.fish, fzf.fish, abbrs_aliases.fish, etc.)
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file &
end

# ###############
#  cache config
# ###############
set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
set -l _stale no
for f in $FISH_CONFIG_DIR/config/*.fish $FISH_CONFIG_DIR/conf.d/*.fish
    test "$f" -nt "$CONFIG_CACHE" && set _stale yes && break
end
if test "$_stale" = yes
    mkdir -p $FISH_CACHE_DIR
    echo '' >$CONFIG_CACHE

    # xcode
    type -q xcode-select && echo "fish_add_path $(xcode-select -p)/usr/bin" >>$CONFIG_CACHE

    # ruby
    type -q mise && mise where ruby &>/dev/null && echo "fish_add_path $(mise where ruby)/bin" >>$CONFIG_CACHE
    type -q gem && echo "fish_add_path $(gem environment gemdir)/bin" >>$CONFIG_CACHE

    type -q android-studio && set -gx ANDROID_HOME ~/Android/Sdk
    type -q android-studio && fish_add_path $ANDROID_HOME/bin

    # tools
    type -q zoxide && zoxide init --cmd cd fish >>$CONFIG_CACHE
    type -q starship && starship init fish >>$CONFIG_CACHE

    set_color brmagenta --bold --underline
    echo "config cache updated"
    set_color normal
end
source $CONFIG_CACHE

# SSH agent bridge (container only): start socat if not running
if test -f /.dockerenv; and test -x "$HOME/.local/bin/ssh-agent-bridge.sh"
    if not test -S "$HOME/.ssh/ssh-agent-bridge.sock"; or not ssh-add -l >/dev/null 2>&1
        bash "$HOME/.local/bin/ssh-agent-bridge.sh"
    end
end

fish_add_path -a "/home/vscode/.config/.foundry/bin"

# Added by LM Studio CLI tool (lms)
set -gx PATH $PATH /home/skmtkytr/.lmstudio/bin
