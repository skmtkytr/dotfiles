-- markdown plugins

return {
  -- {
  --   "MeanderingProgrammer/markdown.nvim",
  --   name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
  --   lazy = true,
  --   ft = "markdown",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("render-markdown").setup({})
  --   end,
  -- },
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    ft = "markdown",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "sunbluesome/holon.nvim",
    keys = {
      { "<leader>zn", "<cmd>Holon<cr>", desc = "Holon: Notes" },
      { "<leader>zg", "<cmd>HolonGrep<cr>", desc = "Holon: Grep" },
      { "<leader>zc", "<cmd>HolonNew<cr>", desc = "Holon: New note" },
      { "<leader>zb", "<cmd>HolonBacklinks<cr>", desc = "Holon: Backlinks" },
      { "<leader>zi", "<cmd>HolonIndexes<cr>", desc = "Holon: Indexes" },
      { "<leader>zj", "<cmd>HolonJournal<cr>", desc = "Holon: Journal" },
      { "<leader>zt", "<cmd>HolonTags<cr>", desc = "Holon: Tags" },
      { "<leader>zT", "<cmd>HolonTypes<cr>", desc = "Holon: Types" },
      { "<leader>zf", "<cmd>HolonFollow<cr>", desc = "Holon: Follow link" },
      { "<leader>zd", "<cmd>HolonToday<cr>", desc = "Holon: Today's journal" },
      { "<leader>zG", "<cmd>HolonGtd<cr>", desc = "Holon: GTD board" },
      { "<leader>zl", "<cmd>HolonBrowse<cr>", desc = "Holon: Link browser" },
      { "<leader>zo", "<cmd>HolonOrphans<cr>", desc = "Holon: Orphan notes" },
    },
    opts = {
      notes_path = vim.fn.expand("~/notes"),
    },
    config = function(_, opts)
      require("holon").setup(opts)
    end,
  },
}
