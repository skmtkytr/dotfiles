-- openapi plugins
return {
  {
    "icholy/lsplinks.nvim",
    event = "LspAttach",
    ft = { "yaml", "json" },
    config = function()
      local lsplinks = require("lsplinks")
      lsplinks.setup()
      vim.keymap.set("n", "gx", lsplinks.gx)
    end,
  },
  {
    "vinnymeller/swagger-preview.nvim",
    ft = "yaml",
    build = "npm install -g swagger-ui-watcher",
    config = function()
      require("swagger-preview").setup({
        -- The port to run the preview server on
        port = 8050,
        -- The host to run the preview server on
        host = "localhost",
      })
    end,
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "spectral",
  --     })
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       spectral = {},
  --     },
  --   },
  -- },
}
