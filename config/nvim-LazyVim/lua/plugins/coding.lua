-- coding plugins
return {
  -- {
  --   "windwp/nvim-autopairs",
  --   event = { "InsertEnter" },
  --   config = function()
  --     require("nvim-autopairs").setup({})
  --   end,
  -- }, -- Autopairs,integrates with both cmp and treesitter

  {
    "Wansmer/treesj",
    keys = { "<space>m", "<space>j" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({--[[ your config ]]
      })
    end,
  },
}
