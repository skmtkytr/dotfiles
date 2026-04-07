# Completions for devnvimserver

function __devnvimserver_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -f -c devnvimserver
complete -c devnvimserver -a '(__devnvimserver_projects)' -d 'Project'
complete -c devnvimserver -a stop -d 'Stop nvim server'
complete -c devnvimserver -l help -s h -d 'Show help'
