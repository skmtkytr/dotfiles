# Completions for devscp

function __devscp_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -c devscp -a '(__devscp_projects)' -d 'Project'
complete -c devscp -l get -d 'Copy from container to local'
complete -c devscp -l help -d 'Show help'
