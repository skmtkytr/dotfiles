-- lsp plugins

return {
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gd", "<cmd>Glance definitions<CR>" },
      { "gr", "<cmd>Glance references<CR>" },
      { "gy", "<cmd>Glance type_definitions<CR>" },
      { "gm", "<cmd>Glance implementations<CR>" },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup()
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
  -- {
  --   "glepnir/lspsaga.nvim",
  --   event = { "LspAttach" },
  --   keys = {
  --     { "K", "<cmd>Lspsaga hover_doc<CR>" },
  --     { "gr", "<cmd>Lspsaga finder<CR>" },
  --     { "gd", "<cmd>Lspsaga peek_definition<CR>" },
  --     { "gdv", ":vsplit | lua vim.lsp.buf.definition()<CR>" },
  --     { "ga", "<cmd>Lspsaga code_action<CR>" },
  --     { "gn", "<cmd>Lspsaga rename<CR>" },
  --     { "<leader>uo", "<cmd>Lspsaga outline<CR>" },
  --     { "ge", "<cmd>Lspsaga show_line_diagnostics<CR>" },
  --     { "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>" },
  --     { "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
  --   },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     -- "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("lspsaga").setup()
  --   end,
  -- }, -- LSP UIs
}
