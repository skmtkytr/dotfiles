-- colorscheme settings

return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro-spectrum",
      -- colorscheme = "tokyonight-night",
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "cyberdream",
    },
  },

  -- add monokai-pro
  {
    "loctvl842/monokai-pro.nvim",
    -- "skmtkytr/monokai-pro.nvim",
    -- branch = "mybranch",
    lazy = true,
    -- opts = {
    --   transparent_background = true,
    -- },
  },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = true,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup({
  --       -- Recommended - see "Configuring" below for more config options
  --       transparent = true,
  --       italic_comments = true,
  --       hide_fillchars = true,
  --       borderless_telescope = true,
  --       terminal_colors = true,
  --     })
  --     vim.cmd("colorscheme cyberdream") -- set the colorscheme
  --   end,
  -- },
}
