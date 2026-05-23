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
  {
    "zk-org/zk-nvim",
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkBacklinks", "ZkLinks", "ZkIndex" },
    keys = {
      {
        "<leader>zkn",
        function()
          require("zk.commands").get("ZkNew")({ title = vim.fn.input("Title: ") })
        end,
        desc = "zk: New note",
      },
      {
        "<leader>zko",
        function()
          require("zk.commands").get("ZkNotes")({ sort = { "modified" } })
        end,
        desc = "zk: Open note",
      },
      { "<leader>zkt", "<Cmd>ZkTags<CR>", desc = "zk: Tags" },
      {
        "<leader>zkf",
        function()
          require("zk.commands").get("ZkNotes")({ sort = { "modified" }, match = { vim.fn.input("Search: ") } })
        end,
        desc = "zk: Search",
      },
      { "<leader>zkb", "<Cmd>ZkBacklinks<CR>", desc = "zk: Backlinks" },
      { "<leader>zkl", "<Cmd>ZkLinks<CR>", desc = "zk: Links" },
      { "<leader>zki", ":'<,'>ZkInsertLinkAtSelection<CR>", mode = "v", desc = "zk: Insert link from selection" },
    },
    config = function()
      require("zk").setup({
        picker = "select",
        lsp = {
          config = {
            cmd = { "zk", "lsp" },
            name = "zk",
          },
          auto_attach = {
            enabled = true,
            filetypes = { "markdown" },
          },
        },
      })
    end,
  },
  -- marksman: general-purpose markdown LSP. Provides documentSymbol
  -- (outline), heading navigation, and link diagnostics for markdown files
  -- outside the zk vault. Coexists with `zk lsp` (different concerns).
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        table.insert(opts.ensure_installed, "marksman")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
}
