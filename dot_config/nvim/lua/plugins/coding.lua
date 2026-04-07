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
    keys = {
      { "<space>m", desc = "toggle treesj" },
      { "<space>j", desc = "fold treesj" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({--[[ your config ]]
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-cmdline",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "nvim_lsp_signature_help" })
      table.insert(opts.sources, { name = "nvim_lsp_document_symbol" })
      table.insert(opts.sources, { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } })
    end,
  },

  -- {
  --   "ray-x/navigator.lua",
  --   event = { "LspAttach" },
  --   config = function()
  --     require("navigator").setup()
  --   end,
  -- },
}
