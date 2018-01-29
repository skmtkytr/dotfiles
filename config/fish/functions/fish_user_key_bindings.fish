function fish_user_key_bindings

    bind \ctt 'peco_todoist_item'
    bind \ctp 'peco_todoist_project'
    bind \ctl 'peco_todoist_labels'
    bind \ctc 'peco_todoist_close'
    bind \ctd 'peco_todoist_delete'
    bind \cr 'peco_select_history (commandline -b)'
    if bind -M insert >/dev/null ^/dev/null
        bind -M insert \cr 'peco_select_history (commandline -b)'

        bind -M insert \ctt 'peco_todoist_item'
        bind -M insert \ctp 'peco_todoist_project'
        bind -M insert \ctl 'peco_todoist_labels'
        bind -M insert \ctc 'peco_todoist_close'
        bind -M insert \ctd 'peco_todoist_delete'
    end

    ### fzf ###
    set -q FZF_LEGACY_KEYBINDINGS
    or set -l FZF_LEGACY_KEYBINDINGS 1
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \cx '__fzf_find_and_execute'
        bind \ec '__fzf_cd'
        bind \eC '__fzf_cd_with_hidden'
        if bind -M insert >/dev/null ^/dev/null
            bind -M insert \ct '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \cx '__fzf_find_and_execute'
            bind -M insert \ec '__fzf_cd'
            bind -M insert \eC '__fzf_cd_with_hidden'
        end
    else
        bind \cf '__fzf_find_file'
        bind \cr '__fzf_reverse_isearch'
        bind \ex '__fzf_find_and_execute'
        bind \eo '__fzf_cd'
        bind \eO '__fzf_cd_with_hidden'
        if bind -M insert >/dev/null ^/dev/null
            bind -M insert \cf '__fzf_find_file'
            bind -M insert \cr '__fzf_reverse_isearch'
            bind -M insert \ex '__fzf_find_and_execute'
            bind -M insert \eo '__fzf_cd'
            bind -M insert \eO '__fzf_cd_with_hidden'
        end
    end
    ### fzf ###
    ### ghq ###
    bind \cg '__ghq_crtl_g'
    if bind -M insert >/dev/null ^/dev/null
        bind -M insert \cg '__ghq_crtl_g'
    end
    ### ghq ###
end
