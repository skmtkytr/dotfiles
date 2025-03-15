-- colorscheme settings

return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "onenord",
      -- colorscheme = "everforest",
      colorscheme = "monokai-pro-spectrum",
      -- colorscheme = "tokyonight-night",
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "cyberdream",
    },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    -- Add in any other configuration;
    --   event = foo,
    --   config = bar
    --   end,
  },
  {
    "rmehri01/onenord.nvim",
    priority = 1000,
    lazy = true,
    config = function()
      require("onenord").setup()
    end,
  },
  {
    "sainnhe/everforest",
    priority = 1000,
    lazy = true,
  },
  {
    "loctvl842/monokai-pro.nvim",
    -- "skmtkytr/monokai-pro.nvim",
    -- branch = "mybranch",
    priority = 1000,
    lazy = true,
    -- opts = {
    --   transparent_background = true,
    -- },
  },
  {
    "nuvic/flexoki-nvim",
    name = "flexoki",
    priority = 1000,
    lazy = true,
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    lazy = true,
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
