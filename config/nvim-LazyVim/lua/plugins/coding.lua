-- coding plugins
return {
  -- {
  --   "windwp/nvim-autopairs",
  --   event = { "InsertEnter" },
  --   config = function()
  --     require("nvim-autopairs").setup({})
  --   end,
  -- }, -- Autopairs,integrates with both cmp and treesitter

  -- {
  --   "nvim-treesitter/playground",
  --   config = function()
  --     require("nvim-treesitter.configs").setup({
  --       playground = {
  --         enable = true,
  --         disable = {},
  --         updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
  --         persist_queries = false, -- Whether the query persists across vim sessions
  --         keybindings = {
  --           toggle_query_editor = "o",
  --           toggle_hl_groups = "i",
  --           toggle_injected_languages = "t",
  --           toggle_anonymous_nodes = "a",
  --           toggle_language_display = "I",
  --           focus_language = "f",
  --           unfocus_language = "F",
  --           update = "R",
  --           goto_node = "<cr>",
  --           show_help = "?",
  --         },
  --       },
  --     })
  --   end,
  -- },
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
