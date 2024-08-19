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
  {
    "glepnir/lspsaga.nvim",
    event = { "LspAttach" },
    keys = {
      { "K", "<cmd>Lspsaga hover_doc<CR>" },
      { "gr", "<cmd>Lspsaga finder<CR>" },
      { "gd", "<cmd>Lspsaga peek_definition<CR>" },
      { "gdv", ":vsplit | lua vim.lsp.buf.definition()<CR>" },
      { "ga", "<cmd>Lspsaga code_action<CR>" },
      { "gn", "<cmd>Lspsaga rename<CR>" },
      { "<leader>uo", "<cmd>Lspsaga outline<CR>" },
      { "ge", "<cmd>Lspsaga show_line_diagnostics<CR>" },
      { "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      -- "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup()
    end,
  }, -- LSP UIs
  -- {
  --   "ray-x/navigator.lua",
  --   event = { "LspAttach" },
  --   config = function()
  --     require("navigator").setup()
  --   end,
  -- },
}
