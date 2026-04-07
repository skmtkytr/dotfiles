# Completions for devport

function __devport_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -f -c devport
complete -c devport -a '(__devport_projects)' -d 'Project'
complete -c devport -a stop -d 'Stop port forwarding'
complete -c devport -l help -d 'Show help'
