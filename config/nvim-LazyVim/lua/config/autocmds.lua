vim.g.deprecation_warnings = true
-- better coop with fzf-lua
vim.env.FZF_DEFAULT_OPTS = ""
vim.g.ai_cmp = false
vim.g.lazyvim_blink_main = not jit.os:find("Windows")
