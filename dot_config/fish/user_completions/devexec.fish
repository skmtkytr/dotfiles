# Completions for devexec

function __devexec_projects
    for meta in $HOME/.devcontainers/*/*/.devup-meta
        test -f "$meta" || continue
        string match -r 'PROJECT=(.*)' <$meta | tail -1
    end
end

complete -c devexec -n '__fish_is_nth_token 1' -a '(__devexec_projects)' -d 'Project'
complete -c devexec -l help -d 'Show help'
