-- rest api client
return {
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1000,
  --   config = true,
  --   opts = {
  --     rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
  --   },
  -- },
  -- {
  --   "rest-nvim/rest.nvim",
  --   keys = {
  --     { "<leader>rr", "<cmd>Rest run<cr>", "Run request under the cursor" },
  --   },
  --   dependencies = { "luarocks.nvim" },
  --   config = function()
  --     require("rest-nvim").setup()
  --   end,
  -- },
  {
    "BlackLight/nvim-http",
    ft = "http",
  },
}
