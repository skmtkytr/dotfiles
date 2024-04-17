-- coding plugins
return {
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function()
      require("nvim-autopairs").setup({})
    end,
  }, -- Autopairs,integrates with both cmp and treesitter
}
