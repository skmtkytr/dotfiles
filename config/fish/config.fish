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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kyo/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/Users/kyo/google-cloud-sdk/path.fish.inc'; else; . '/Users/kyo/google-cloud-sdk/path.fish.inc'; end; end