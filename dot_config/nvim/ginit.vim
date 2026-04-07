" ginit.vim - GUI-specific settings (loaded by Neovide before ui_attach)
" vim.g.neovide is already set via RPC when this runs.
" NOTE: init.lua/options.lua cannot check vim.g.neovide reliably because
"       Neovide sets it via RPC after nvim config loading completes.

if exists('g:neovide')
    set guifont=UDEV\ Gothic\ 35NFLG,Symbols\ Nerd\ Font\ Mono:h13
    let g:neovide_scale_factor = 1
    set linespace=1
    let g:neovide_input_macos_option_key_is_meta = 'only_left'
    let g:neovide_cursor_antialiasing = v:true
endif
