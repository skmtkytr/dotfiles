local Util = require("util")

vim.api.nvim_create_augroup('vimrc-auto-mkdir', {})

vim.cmd('augroup vimrc-auto-mkdir')
vim.cmd('autocmd BufWritePre * call s:auto_mkdir(expand("<afile>:p:h\\"), v:cmdbang)')
vim.cmd('function! s:auto_mkdir(dir, force)')
vim.cmd('if !isdirectory(a:dir) && (a:force || input(printf(\'"%s" does not exist. Create? [y/N]\', a:dir)) =~? \'^y\\%[es]$\')')
vim.cmd('call mkdir(iconv(a:dir, &encoding, &termencoding), "p")')
vim.cmd('endif')
vim.cmd('endfunction')
vim.cmd('augroup END')

--   
--   function! s:auto_mkdir(dir, force)
--     if !isdirectory(a:dir) && (a:force || input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
--       call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
--     endif
--   endfunction
-- augroup END
--

-- Highlight on yank
-- vim.api.nvim_create_autocmd({ "TextYankPost" }, {
--   group = Util.augroup("highlight_yank"),
--   callback = function()
--     vim.highlight.on_yank({ higroup = "Visual" })
--   end,
-- })

-- resize splits if window got resized
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   group = Util.augroup("resize_splits"),
--   callback = function()
--     vim.cmd("tabdo wincmd =")
--   end,
-- })

