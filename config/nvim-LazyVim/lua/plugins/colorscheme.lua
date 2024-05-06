-- colorscheme settings

return {
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "monokai-pro-spectrum",
      -- colorscheme = "tokyonight",
    },
  },

  -- add monokai-pro
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
  },
}
