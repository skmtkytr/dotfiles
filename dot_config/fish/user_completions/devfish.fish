# Completions for devfish

function __devfish_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -f -c devfish
complete -c devfish -a '(__devfish_projects)' -d 'Project'
complete -c devfish -l help -s h -d 'Show help'
