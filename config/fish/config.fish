# ###############
# # fish config
# ###############
########################################
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# define XDG paths
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache
# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR $HOME/.cache/fish

# add user config
set -gp fish_function_path $FISH_CONFIG_DIR/user_functions $fish_function_path
# function load_user_config
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file &
end

if status --is-interactive
    # Ensure fisherman and plugins are installed
    # if not test -f $HOME/.config/fish/functions/fisher.fish
    #     echo "==> Fisherman not found.  Installing."
    #     curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
    #     fisher
    # end
end

# if status is-interactive
#     and not set -q TMUX
#     if tmux has-session -t default
#         exec tmux attach-session -t default
#     else
#         tmux new-session -s default
#     end
# end

# if test $SHLVL -eq 0
#   tmux a
# elsif test (tmux has) -eq 1
#   tmux
# end
# theme
set -gx theme_nerd_fonts yes
set -gx BIT_THEME monochrome

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/google-cloud-sdk/path.fish.inc' ]
    if type source >/dev/null
        source '/Users/kyo/google-cloud-sdk/path.fish.inc'
    else
        . '/Users/kyo/google-cloud-sdk/path.fish.inc'
    end
end
# set -g fish_user_paths /usr/local/opt/openssl/bin $fish_user_paths

set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME /Users/skmtkytr/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# Neovim
if type -q nvim
    set -gx EDITOR nvim
    set -gx GIT_EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim -c ASMANPAGER -"
end

# ###############
#  cache config
# ###############
set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
if test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    mkdir -p $FISH_CACHE_DIR
    echo '' >$CONFIG_CACHE

    # xcode
    type -q xcode-select && echo "fish_add_path $(xcode-select -p)/usr/bin" >>$CONFIG_CACHE

    # ruby
    # type -q brew && echo "fish_add_path $(brew --prefix)/opt/ruby/bin" >>$CONFIG_CACHE
    type -q mise && mise activate fish >>$CONFIG_CACHE
    type -q mise && echo "fish_add_path $(mise where ruby)/bin" >>$CONFIG_CACHE
    type -q gem && echo "fish_add_path $(gem environment gemdir)/bin" >>$CONFIG_CACHE
    # asdf exec direnv hook fish | source
    # source /opt/homebrew/opt/asdf/libexec/asdf.fish

    # tools
    # type -q direnv && direnv hook fish >>$CONFIG_CACHE
    type -q zoxide && zoxide init fish >>$CONFIG_CACHE
    type -q pyenv && pyenv init - >>$CONFIG_CACHE
    starship init fish >>$CONFIG_CACHE

    set_color brmagenta --bold --underline
    echo "config cache updated"
    set_color normal
end
source $CONFIG_CACHE

set -g NA_PACKAGE_MANAGER_LIST bun deno pnpm npm yarn mise
set -g NA_FUZZYFINDER_OPTIONS --bind 'one:accept' --query '^'
