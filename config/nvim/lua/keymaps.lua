local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
-- keymap("", "<Space>", "<Nop>", opts)
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- New tab
keymap("n", "te", ":tabedit", opts)
-- 新しいタブを一番右に作る
keymap("n", "gn", ":tabnew<Return>", opts)
-- move tab
--keymap("n", "gh", "gT", opts)
--keymap("n", "gl", "gt", opts)

-- Split window
--keymap("n", "ss", ":split<Return><C-w>w", opts)
--keymap("n", "sv", ":vsplit<Return><C-w>w", opts)

-- Select all
--keymap("n", "<C-a>", "gg<S-v>G", opts)

-- Do not yank with x
keymap("n", "x", '"_x', opts)

-- Delete a word backwards
keymap("n", "dw", 'vb"_d', opts)

-- 行の端に行く
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)

-- ;でコマンド入力( ;と:を入れ替)
--keymap("n", ";", ":", opts)

-- 行末までのヤンクにする
keymap("n", "Y", "y$", opts)

-- <Space>q で強制終了
--keymap("n", "<Space>q", ":<C-u>q!<Return>", opts)

-- ESC*2 でハイライトやめる
--keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)

-- Insert --
-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)

-- コンマの後に自動的にスペースを挿入
--keymap("i", ",", ",<Space>", opts)

-- Visual --
-- Stay in indent mode
--keymap("v", "<", "<gv", opts)
--keymap("v", ">", ">gv", opts)

-- ビジュアルモード時vで行末まで選択
keymap("v", "v", "$h", opts)

-- 0番レジスタを使いやすくした
--keymap("v", "<C-p>", '"0p', opts)

-- builtin LSP funcion keymap
-- keymap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
keymap('n', 'gf', '<cmd>lua vim.lsp.buf.format({async=false})<CR>', opts)
-- keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
-- keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
-- keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- keymap('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- keymap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
-- keymap('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
-- keymap('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- keymap('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

keymap("n", "K",  "<cmd>Lspsaga hover_doc<CR>", opts)
keymap('n', 'gr', '<cmd>Lspsaga finder<CR>', opts)
keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
keymap("n", "ga", "<cmd>Lspsaga code_action<CR>", opts)
keymap("n", "gn", "<cmd>Lspsaga rename<CR>", opts)
keymap("n", "<S-o>", "<cmd>Lspsaga outline<CR>", opts)
keymap("n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)

-- CMP keymap
-- keymap("i", "<C-Space>", "cmp#complete()", opts)
-- keymap("i", "<CR>", "cmp#confirm('<CR>')", opts)
-- keymap("i", "<C-e>", "cmp#close('<C-e>')", opts)
-- keymap("i", "<C-f>", "cmp#scroll({ 'delta': +4 })", opts)
-- keymap("i", "<C-d>", "cmp#scroll({ 'delta': -4 })", opts)


-- Comment out
keymap('n', '<Leader>c', '<Plug>(caw:hatpos:toggle)', {})
keymap('v', '<Leader>c', '<Plug>(caw:hatpos:toggle)', {})
keymap('n', '<Leader>,', '<Plug>(caw:zeropos:toggle)', {})
keymap('v', '<Leader>,', '<Plug>(caw:zeropos:toggle)', {})

-- test
keymap('n', '<leader>rtb', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opts) -- Run Test Buffer
keymap('n', '<leader>rtc', '<cmd>lua require("neotest").run.run()<CR>', opts) -- Run Test Current Cursor

-- Telescope mappings
-- keymap("n", "<C-p>", "<cmd>Telescope fd theme=dropdown<cr>", opts)
-- keymap("n", "<Space>f", "<cmd>Telescope live_grep theme=dropdown<cr>", opts)
-- keymap("n", "gcf", "<cmd>Telescope grep_string theme=dropdown<cr>", opts)

-- hop
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ current_line_only = false })
  -- hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = false })
end, {remap=true})
-- vim.keymap.set('', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})

