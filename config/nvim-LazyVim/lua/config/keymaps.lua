local util = require("util")
local map = vim.keymap

-- map.set("i", "jj", "<ESC>", { desc = "escape insert mode.", noremap = true })
util.cowboy()

-- terminal keymaps(fzflua keymaps)
map.set("t", "<c-h>", "<left>", { desc = "" })
map.set("t", "<c-j>", "<down>", { desc = "" })
map.set("t", "<c-k>", "<up>", { desc = "" })
map.set("t", "<c-l>", "<right>", { desc = "" })

map.set("n", "ciy", "ciw<C-r>0<ESC>", { desc = "change in yank" })
