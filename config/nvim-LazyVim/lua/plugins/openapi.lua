-- openapi plugins
return {
  {
    "icholy/lsplinks.nvim",
    config = function()
      local lsplinks = require("lsplinks")
      lsplinks.setup()
      vim.keymap.set("n", "gx", lsplinks.gx)
    end,
  },
  {
    "vinnymeller/swagger-preview.nvim",
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
}
