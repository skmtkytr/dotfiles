vim.loader.enable()

-- 存在確認する場合
if vim.loader then vim.loader.enable() end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("base")
require("options")
require("plugins_lazy")
require("autocmds")
require("keymaps")
require("colorscheme")
