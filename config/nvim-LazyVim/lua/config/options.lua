-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  --   encoding = "utf-8",
  --   fileencoding = "utf-8",
  --   title = true,
  --   grepprg = "rg --vimgrep",
  --   backup = false,
  clipboard = "unnamedplus",
  --   cmdheight = 2,
  --   completeopt = { "menuone", "noselect" },
  --   conceallevel = 0,
  --   hlsearch = true,
  --   ignorecase = true,
  --   mouse = "a",
  --   pumheight = 10,
  --   showmode = false,
  --   showtabline = 2,
  --   smartcase = true,
  --   smartindent = true,
  --   swapfile = false,
  termguicolors = true,
  --   timeoutlen = 300,
  --   undofile = true,
  --   updatetime = 300,
  --   writebackup = false,
  --   shell = "fish",
  --   backupskip = { "/tmp/*", "/private/tmp/*" },
  --   shortmess = "I",
  --   expandtab = true,
  --   shiftwidth = 2,
  --   tabstop = 2,
  --   cursorline = true,
  --   number = true,
  --   relativenumber = true,
  --   numberwidth = 4,
  --   laststatus = 3,
  signcolumn = "yes",
  --   wrap = false,
  winblend = 10,
  --   wildoptions = "pum",
  --   pumblend = 5,
  --   background = "dark",
  --   scrolloff = 8,
  --   sidescrolloff = 8,
  --   guifont = "monospace:h17",
  --   list = true, -- 不可視文字の可視化
  --   listchars = { tab = ">>", trail = "-", nbsp = "+" },
  --   splitbelow = false, -- オンのとき、ウィンドウを横分割すると新しいウィンドウはカレントウィンドウの下に開かれる
  --   splitright = false, -- オンのとき、ウィンドウを縦分割すると新しいウィンドウはカレントウィンドウの右に開かれる
  --   splitkeep = "screen",
  whichwrap = "<,>,[,],h,l", -- 行末での折り返しを無効にする
  --   sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
}
--
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none", fg = "none" })
-- vim.opt.shortmess:append("c")
--
for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.highlight.priorities.semantic_tokens = 95 -- Or any number lower than 100, treesitter's priority level
