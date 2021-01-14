"---------------------------------------------------------------------------
" denite.nvim
"

if executable('rg')
  call denite#custom#var('file/rec', 'command',
        \ ['rg', '--files', '--glob', '!.git', '--color', 'never'])
  call denite#custom#var('grep', {
        \ 'command': ['rg', '--threads', '1'],
        \ 'recursive_opts': [],
        \ 'final_opts': [],
        \ 'separator': ['--'],
        \ 'default_opts': ['-i', '--vimgrep', '--no-heading'],
        \ })
else
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#source('file/old', 'matchers', [
      \ 'matcher/clap', 'matcher/project_files', 'matcher/ignore_globs',
      \ ])
call denite#custom#source('tag', 'matchers', ['matcher/substring'])
call denite#custom#source('file/old,ghq', 'converters',
      \ ['converter/relative_word', 'converter/relative_abbr'])

call denite#custom#alias('source', 'file/git', 'file/rec')
call denite#custom#var('file/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

let s:clap_path = dein#get('vim-clap')['path']
call denite#custom#filter('matcher/clap', 'clap_path', s:clap_path)
call denite#custom#source('file/rec,grep,jump,buffer,file_mru,tag',
			\ 'matchers', [ 'matcher/clap' ])

call denite#custom#alias('source', 'file/dirty', 'file/rec')
call denite#custom#var('file/dirty', 'command',
      \ ['git', 'ls-files', '-mo',
      \  '--directory', '--no-empty-directory', '--exclude-standard'])

" call denite#custom#option('default', 'prompt', '>')
" call denite#custom#option('default', 'short_source_names', v:true)
if has('nvim')
  call denite#custom#option('default', {
        \ 'highlight_filter_background': 'CursorLine',
        \ 'source_names': 'short',
        \ 'split': 'floating',
        \ 'filter_split_direction': 'floating',
        \ 'vertical_preview': v:true,
        \ 'floating_preview': v:true,
        \ })
else
  call denite#custom#option('default', {
        \ 'highlight_filter_background': 'CursorLine',
        \ 'source_names': 'short',
        \ 'vertical_preview': v:true,
        \ })
endif
call denite#custom#option('search', {
      \ 'highlight_filter_background': 'CursorLine',
      \ 'source_names': 'short',
      \ 'filter_split_direction': 'floating',
      \ })

let s:menus = {}
let s:menus.vim = {
    \ 'description': 'Vim',
    \ }
let s:menus.vim.file_candidates = [
    \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
" call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
"    \ [
"    \ '.git/', 'build/', '__pycache__/', 'Cache/', '~/Library/Caches/',
"    \ 'images/', '*.o', '*.make',
"    \ '*.min.*', 'log/',
"    \ 'img/', 'fonts/'])
" 
"      " Change sorters.
"      call denite#custom#source(
"     \ 'file/rec', 'sorters', ['sorter_sublime'])
" 
" if executable('rg')
"   call denite#custom#var('file/rec', 'command',
"      \ ['rg', '--files', '--glob', '!.git'])
"   call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
"   call denite#custom#var('grep', 'recursive_opts', [])
"   call denite#custom#var('grep', 'final_opts', [])
"   call denite#custom#var('grep', 'separator', ['--'])
"   call denite#custom#var('grep', 'default_opts',
"      \ ['-i', '--vimgrep', '--no-heading'])
" endif
" 
" call denite#custom#source('file/old', 'matchers',
   "\ ['matcher/fruzzy', 'matcher/project_files'])
" call denite#custom#source('tag', 'matchers', ['matcher/substring'])
" call denite#custom#source('file/rec', 'matchers',
"    \ ['matcher/fruzzy'])
" call denite#custom#source('file/old', 'converters',
"    \ ['converter/relative_word'])
" 
" 
" " if has('nvim')
" call denite#custom#source('_', 'matchers',
"   \ ['matcher/fruzzy'])
" " endif
" 
" call denite#custom#alias('source', 'file/rec/git', 'file/rec')
" call denite#custom#var('file/rec/git', 'command',
"    \ ['git', 'lsfiles', '-co', '--exclude-standard'])
" 
" let s:denite_win_width_percent = 0.85
" let s:denite_win_height_percent = 0.7
" " call denite#custom#option('default', 'prompt', '>')
" call denite#custom#option('default', 'short_source_names', v:true)
" call denite#custom#option('default', {
"    \ 'auto_accel': v:true,
"    \ 'prompt': '>',
"    \ 'source_names': 'short',
"    \ })


"         \ 'highlight_filter_background': 'CursorLine',
"     \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
"    \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
""    \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
""    \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
call denite#custom#option('default', {
     \ 'prompt': '>> ',
     \ 'source_names': 'short',
"\ 'split': 'floating',
     \ 'start_filter': 'true',
     \ })


let s:menus = {}
let s:menus.vim = {
  \ 'description': 'Vim',
  \ }
let s:menus.vim.file_candidates = [
  \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
  \ ]
let s:menus.dein = { 'description': '⚔️  Plugin management' }
let s:menus.dein.command_candidates = [
  \   ['🐬 Dein: Plugins update 🔸', 'call dein#update()'],
  \   ['🐬 Dein: Plugins List   🔸', 'Denite dein'],
  \   ['🐬 Dein: Update log     🔸', 'echo dein#get_updates_log()'],
  \   ['🐬 Dein: Log            🔸', 'echo dein#get_log()'],
  \ ]

let s:menus.project = { 'description': '🛠  Project & Structure' }
let s:menus.project.command_candidates = [
  \   ['🐳 File Explorer        🔸<Leader>e',        'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \   ['🐳 Outline              🔸<LocalLeader>t',   'TagbarToggle'],
  \   ['🐳 Git Status           🔸<LocalLeader>gs',  'Denite gitstatus'],
  \   ['🐳 Mundo Tree           🔸<Leader>m',  'MundoToggle'],
  \ ]

let s:menus.files = { 'description': '📁 File tools' }
let s:menus.files.command_candidates = [
  \   ['📂 Denite: Find in files…    🔹 ',  'Denite grep:.'],
  \   ['📂 Denite: Find files        🔹 ',  'Denite file/rec'],
  \   ['📂 Denite: Buffers           🔹 ',  'Denite buffer'],
  \   ['📂 Denite: MRU               🔹 ',  'Denite file/old'],
  \   ['📂 Denite: Line              🔹 ',  'Denite line'],
  \ ]

let s:menus.tools = { 'description': '⚙️  Dev Tools' }
let s:menus.tools.command_candidates = [
  \   ['🐠 Git commands       🔹', 'Git'],
  \   ['🐠 Git log            🔹', 'Denite gitlog:all'],
  \   ['🐠 Goyo               🔹', 'Goyo'],
  \   ['🐠 Tagbar             🔹', 'TagbarToggle'],
  \   ['🐠 File explorer      🔹', 'Defx -resume -toggle -buffer-name=tab`tabpagenr()`<CR>'],
  \ ]

let s:menus.todoapp = { 'description': '🗓  Todo List' }
let s:menus.todoapp.command_candidates = [
  \   ['📝 TodoAdd            🔸', 'TodoAdd '],
  \   ['📝 TodoList           🔸', 'Denite todo'],
  \   ['📝 TodoDone           🔸', 'Denite todo:done'],
  \ ]

let s:menus.config = { 'description': '🔧 fish Tmux Configuration' }
let s:menus.config.file_candidates = [
  \   ['🐠 fish Configurationfile            🔸', '~/.config/fish/config.fish '],
  \   ['🐠 Tmux Configurationfile           🔸', '~/.tmux.conf '],
  \ ]

let s:menus.thinkvim = {'description': '💎 ThinkVim Configuration files'}
let s:menus.thinkvim.file_candidates = [
  \   ['🐠 General settings: vimrc                   🔹', $VIMPATH.'/core/vimrc'],
  \   ['🐠 Initial settings: init.vim                🔹', $VIMPATH.'/core/init.vim'],
  \   ['🐠 File Types: vimrc.filetype                🔹', $VIMPATH.'/core/filetype.vim'],
  \   ['🐠 Installed Plugins: dein.toml              🔹', $VIMPATH.'/core/dein/dein.toml'],
  \   ['🐠 Installed LazyLoadPlugins: deinlazy.toml  🔹', $VIMPATH.'/core/dein/deinlazy.toml'],
  \   ['🐠 Global Key mappings: mappings             🔹', $VIMPATH.'/core/mappings.vim'],
  \   ['🐠 Global Key Pluginmappings: Pluginmappings 🔹', $VIMPATH.'/core/plugins/allkey.vim'],
  \ ]

call denite#custom#var('menu', 'menus', s:menus)
" deniteの起動位置をtopに変更
"call denite#custom#option('default', 'direction', 'top')

"" Shogo's settings

" if executable('rg')
"   call denite#custom#var('file/rec', 'command',
"        \ ['rg', '--files', '--glob', '!.git'])
"   call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
"   call denite#custom#var('grep', 'recursive_opts', [])
"   call denite#custom#var('grep', 'final_opts', [])
"   call denite#custom#var('grep', 'separator', ['--'])
"   call denite#custom#var('grep', 'default_opts',
"        \ ['-i', '--vimgrep', '--no-heading'])
" else
"   call denite#custom#var('file/rec', 'command',
"        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
" endif
"
" call denite#custom#source('file/old', 'matchers',
"      \ ['matcher/fruzzy', 'matcher/project_files'])
" call denite#custom#source('tag', 'matchers', ['matcher/substring'])
" call denite#custom#source('file/rec', 'matchers',
"      \ ['matcher/fruzzy'])
" call denite#custom#source('file/old', 'converters',
"      \ ['converter/relative_word'])
"
" call denite#custom#alias('source', 'file/rec/git', 'file/rec')
" call denite#custom#var('file/rec/git', 'command',
"      \ ['git', 'ls-files', '-co', '--exclude-standard'])
"
" call denite#custom#option('default', 'prompt', '>')
" call denite#custom#option('default', 'short_source_names', v:true)
" " call denite#custom#option('default', {
" "      \ 'highlight_filter_background': 'CursorLine',
" "      \ 'source_names': 'short',
" "      \ 'split': 'floating',
" "      \ })
"
" let s:menus = {}
" let s:menus.vim = {
"    \ 'description': 'Vim',
"    \ }
" let s:menus.vim.file_candidates = [
"    \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/init.vim']
"    \ ]
" call denite#custom#var('menu', 'menus', s:menus)
"
" call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
"      \ [ '.git/', '.ropeproject/', '__pycache__/',
"      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])
