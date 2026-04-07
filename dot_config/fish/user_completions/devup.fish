# Completions for devup
complete -f -c devup
complete -c devup -l sync -d 'Re-run chezmoi apply inside container'
complete -c devup -l remove-existing-container -d 'Remove and recreate container'
complete -c devup -l rebuild-no-cache -d 'Rebuild image without cache'
complete -c devup -l help -d 'Show help'
