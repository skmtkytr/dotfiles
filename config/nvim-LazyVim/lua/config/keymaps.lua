local util = require("util")
local map = vim.keymap

-- map.set("i", "jj", "<ESC>", { desc = "escape insert mode.", noremap = true })
util.cowboy()

if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

-- terminal keymaps(fzflua keymaps)
map.set("t", "<c-h>", "<left>", { desc = "" })
map.set("t", "<c-j>", "<down>", { desc = "" })
map.set("t", "<c-k>", "<up>", { desc = "" })
map.set("t", "<c-l>", "<right>", { desc = "" })

map.set("n", "ciy", "ciw<C-r>0<ESC>", { desc = "change in yank" })
