# ###############
# # fish config
# ###############
if status --is-interactive
    # load alias & functions
    . ~/.config/fish/aliases.fish

    # load env fish
    . ~/.config/fish/env.fish

    # Ensure fisherman and plugins are installed
    if not test -f $HOME/.config/fish/functions/fisher.fish
        echo "==> Fisherman not found.  Installing."
        curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
        fisher
    end
end

if status is-interactive
    and not set -q TMUX
    if tmux has-session -t default
        exec tmux attach-session -t default
    else
        tmux new-session -s default
    end
end

# if test $SHLVL -eq 0
#   tmux a
# elsif test (tmux has) -eq 1
#   tmux
# end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/google-cloud-sdk/path.fish.inc' ]
    if type source >/dev/null
        source '/Users/kyo/google-cloud-sdk/path.fish.inc'
    else
        . '/Users/kyo/google-cloud-sdk/path.fish.inc'
    end
end
set -g fish_user_paths /usr/local/opt/openssl/bin $fish_user_paths
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

source /opt/homebrew/opt/asdf/libexec/asdf.fish
