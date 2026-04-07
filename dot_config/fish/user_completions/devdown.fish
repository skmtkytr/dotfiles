# Completions for devdown

function __devdown_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -f -c devdown
complete -c devdown -a '(__devdown_projects)' -d 'Project'
complete -c devdown -l keep-volume -d 'Keep workspace volume'
complete -c devdown -l all -d 'Remove all devcontainers'
complete -c devdown -l help -s h -d 'Show help'
