if vim.env.VSCODE then
  vim.g.vscode = true
end

-- Headless server mode: :qa detaches UI instead of quitting the server
if vim.env.NVIM_HEADLESS_SERVER == "1" then
  vim.g.headless_server = true
  local function detach_uis()
    for _, ui in ipairs(vim.api.nvim_list_uis()) do
      if ui.chan and ui.chan > 0 then
        pcall(vim.fn.chanclose, ui.chan)
      end
    end
  end

  vim.api.nvim_create_user_command("Detach", detach_uis, {})

  for _, cmd in ipairs({ "q", "qa", "wq", "wqa" }) do
    vim.cmd(([[cnoreabbrev <expr> %s getcmdtype()==":"&&getcmdline()=="%s" ? "Detach" : "%s"]]):format(cmd, cmd, cmd))
  end

  -- OSC 52: yank reaches host clipboard via terminal escape sequence
  -- paste uses internal register (OSC 52 paste requires terminal response which times out)
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = function() return vim.fn.getreg("+", true, true) end,
      ["*"] = function() return vim.fn.getreg("*", true, true) end,
    },
  }
end

if vim.loader then
  vim.loader.enable()
end

_G.dd = function(...)
  require("snacks.debug").inspect(...)
end

if vim.env.PROF then
  -- example for lazy.nvim
  -- change this to the correct path for your plugin manager
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup({
    startup = {
      -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
      -- event = "UIEnter",
      -- event = "VeryLazy",
    },
  })
end

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy").load({
  -- debug = false,
  profiling = {
    loader = false,
    require = true,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
