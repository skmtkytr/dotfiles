# Bootstrap fisher plugins on first interactive shell if setup.sh failed
if status is-interactive
    and functions -q fisher
    and not functions -q _fzf_search_history
    echo "Fisher plugins missing, running fisher update..."
    fisher update
end
