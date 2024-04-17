-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap

-- map.set("i", "jj", "<ESC>", { desc = "escape insert mode.", noremap = true })

-- terminal keymaps(fzflua keymaps)
map.set("t", "<c-h>", "<left>", { desc = "" })
map.set("t", "<c-j>", "<down>", { desc = "" })
map.set("t", "<c-k>", "<up>", { desc = "" })
map.set("t", "<c-l>", "<right>", { desc = "" })
