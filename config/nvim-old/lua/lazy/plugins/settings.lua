local util = require("util")

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    util.load("autocmds")
    util.load("keymaps")
  end,
})

util.load("base")
util.load("options")

return {}
