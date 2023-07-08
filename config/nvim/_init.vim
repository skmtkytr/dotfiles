let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME

" clip board "
set clipboard+=unnamedplus

" encoding {{{
set encoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp
scriptencoding utf-8
" Not show command on statusline.
set noshowcmd

set mouse=a
set wildoptions+=pum

"" incsubstitution
set inccommand=split

"" Spell Check
set spelllang=en,cjk
" fun! s:SpellConf()
"   redir! => syntax
"   silent syntax
"   redir END
"
"   set spell
"
"   if syntax =~? '/<comment\>'
"     syntax spell default
"     syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent containedin=Comment contained
"   else
"     syntax spell toplevel
"     syntax match SpellMaybeCode /\<\h\l*[_A-Z]\h\{-}\>/ contains=@NoSpell transparent
"   endif
"
"   syntax cluster Spell add=SpellNotAscii,SpellMaybeCode
" endfunc
"
" augroup spell_check
"   autocmd!
"   autocmd BufReadPost,BufNewFile,Syntax * call s:SpellConf()
" augroup END

" vimlog
"set verbosefile=~/vim.log
"set verbose=20

" reset augroup
augroup MyAutoCmd
    autocmd!
augroup END

" dein {{{
let s:dein_cache_dir = g:cache_home . '/dein'

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_cache_dir . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    " dein.vim をプラグインとして読み込む
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

" dein.vim settings
let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

if dein#load_state(s:dein_cache_dir)
    call dein#begin(s:dein_cache_dir)

    let s:toml_dir = g:config_home . '/dein'

    call dein#load_toml(s:toml_dir . '/plugins.toml', {'lazy': 0})
    call dein#load_toml(s:toml_dir . '/lazy.toml', {'lazy': 1})
    if has('nvim')
        call dein#load_toml(s:toml_dir . '/neovim.toml', {'lazy': 0})
    endif

    if exists('g:vscode')
      " vscodeの場合こちらのプラグインを利用
      call dein#add('asvetliakov/vim-easymotion')
      " sで任意の２文字から始まる場所へジャンプ
      nmap s <Plug>(easymotion-s2)
    else
    endif

    call dein#end()
    call dein#save_state()
endif

if has('vim_starting') && dein#check_install()
    call dein#install()
endif

" neocomplete 
let g:neocomplete#enable_at_startup = 1

" deoplete
let g:deoplete#enable_at_startup = 1

execute pathogen#infect()

" hop {{{
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})


" syntastic {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" }}}

"" lightline {{{
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ],
      \             ['readonly', 'filename', 'modified', 'ale'],
      \           ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'readonly': 'LightlineReadonly',
      \   'modified': 'LightlineModified',
      \   'filename': 'LightlineFilename',
      \   'ale': 'ALEGetStatusLine'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! ALEStatus()
  return ALEGetStatusLine()
endfunction

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return ""
  else
    return ""
  endif
endfunction

function! LightlineFugitive()
  if exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
       \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
       \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

"}}}


"" NERDTree {{{
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules', 'bower_components']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 25
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite<Paste>
"autocmd vimenter * NERDTree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

map <F9> :NERDTreeToggle<CR>
"" }}}

" tagbar {{{
if ! empty(dein#get("tagbar"))
  let g:tagbar_width = 30
  nn <silent> <leader>t :TagbarToggle<CR>
endif
"set tags+=.tags
" ファイルタイプ毎 & gitリポジトリ毎にtagsの読み込みpathを変える
function! ReadTags(type)
    try
        execute "set tags=".$HOME."/dotfiles/tags_files/".
              \ system("cd " . expand('%:p:h') . "; basename `git rev-parse --show-toplevel` | tr -d '\n'").
              \ "/" . a:type . "_tags"
    catch
        execute "set tags=./tags/" . a:type . "_tags;"
    endtry
endfunction

"augroup TagsAutoCmd
"    autocmd!
"    autocmd BufEnter * :call ReadTags(&filetype)
"augroup END
" }}}

" Indent Width
set shiftwidth=2
set tabstop=2

augroup indent
  autocmd! FileType python setlocal shiftwidth=4 tabstop=4
  autocmd! FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2
  autocmd! FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" erb HTML5 indentation Enable from html5.vim 
autocmd BufRead,BufNewFile *.erb set filetype=eruby.html

set autoindent
set expandtab

" visual setting
syntax enable
" autocmd ColorScheme * highlight Normal ctermbg=none
" autocmd ColorScheme * highlight LineNr ctermbg=none
" colorscheme solarized
"colorscheme monokai
colorscheme iceberg
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

"" background through
  highlight Normal ctermbg=NONE guibg=NONE
  highlight NonText ctermbg=NONE guibg=NONE
  highlight LineNr ctermbg=NONE guibg=NONE
  highlight SpecialKey ctermbg=NONE guibg=NONE
  highlight Folded ctermbg=NONE guibg=NONE
  highlight EndOfBuffer ctermbg=NONE guibg=NONE


augroup TransparentBG
  	autocmd!
	autocmd Colorscheme * highlight Normal ctermbg=none guibg=NONE
	autocmd Colorscheme * highlight NonText ctermbg=none guibg=NONE
	autocmd Colorscheme * highlight LineNr ctermbg=none guibg=NONE
	autocmd Colorscheme * highlight Folded ctermbg=none guibg=NONE
	autocmd Colorscheme * highlight EndOfBuffer ctermbg=none guibg=NONE
augroup END

" set background=dark
set number
set ruler
set cursorline
" set relativenumber

" keymap {{{
nmap <F8> :TagbarToggle<CR>
nnoremap <F3> :<C-u>setlocal relativenumber!<CR>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

"nnoremap <silent> <Space>f :Gtags -f %<CR>
nnoremap <silent> <Space>j :GtagsCursor<CR>
nnoremap <silent> <Space>d :<C-u>exe('Gtags '.expand('<cword>'))<CR>
nnoremap <silent> <Space>r :<C-u>exe('Gtags -r '.expand('<cword>'))<CR>
" }}}

" previm {{{
let g:previm_open_cmd = 'open -a Chrome'
" }}}

" vim-misc settings {{{
" 現在のディレクトリ直下の .vimsessions/ を取得 
let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
" 存在すれば
if isdirectory(s:local_session_directory)
  " session保存ディレクトリをそのディレクトリの設定
  let g:session_directory = s:local_session_directory
  " vimを辞める時に自動保存
  let g:session_autosave = 'yes'
  " 引数なしでvimを起動した時にsession保存ディレクトリのdefault.vimを開く
  let g:session_autoload = 'yes'
  " 1分間に1回自動保存
  let g:session_autosave_periodic = 1
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory
" }}}

"" vim-ref config
let g:ref_refe_cmd = $HOME.'/.rbenv/shims/refe' "vim-ref command path

"" neovim python support
let g:python_host_prog=$PYENV_ROOT.'/versions/neovim-2/bin/python'
let g:python3_host_prog=$PYENV_ROOT.'/versions/neovim-3/bin/python'



" }}}
