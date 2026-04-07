function fish_user_key_bindings

    bind \ctt 'peco_todoist_item'
    bind \ctp 'peco_todoist_project'
    bind \ctl 'peco_todoist_labels'
    bind \ctc 'peco_todoist_close'
    bind \ctd 'peco_todoist_delete'
    # Ctrl+R history search is handled by patrickf1/fzf.fish plugin
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \ctt 'peco_todoist_item'
        bind -M insert \ctp 'peco_todoist_project'
        bind -M insert \ctl 'peco_todoist_labels'
        bind -M insert \ctc 'peco_todoist_close'
        bind -M insert \ctd 'peco_todoist_delete'
    end

    ### fzf ###
    # fzf key bindings are managed by patrickf1/fzf.fish plugin
    ### fzf ###
    ### ghq ###
    # ghq keybindings are managed by conf.d/ghq_key_bindings.fish
    ### ghq ###
end
