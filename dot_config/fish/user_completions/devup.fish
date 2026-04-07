# Completions for devup

function __devup_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

# Disable file completions
complete -f -c devup

# Projects (owner/repo)
complete -c devup -n 'not __fish_seen_argument -l host -l new -l sync -l help' \
    -a '(__devup_projects)' -d 'Project'

# Options
complete -c devup -l host -s h -r -d 'Remote Docker host (user@server)'
complete -c devup -l new -r -d 'Create new GitHub repo'
complete -c devup -l sync -d 'Update dotfiles in container'
complete -c devup -l remove-existing-container -d 'Remove and recreate container'
complete -c devup -l rebuild-no-cache -d 'Rebuild image without cache'
complete -c devup -l help -d 'Show help'
