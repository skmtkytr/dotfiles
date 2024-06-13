-- git plugins
return {
  {
    "tpope/vim-fugitive",
    -- lazy = true,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gN", "<cmd>Neogit<cr>", mode = { "n" }, desc = "Neogit" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    config = true,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      opts["current_line_blame"] = true
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
      local ok, scrollbar = pcall(require, "scrollbar.handlers.gitsigns")
      if ok then
        scrollbar.setup()
      end
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    opts = {},
    keys = {
      { "<leader>gy", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Yank git link" },
      { "<leader>gY", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
    },
  },
}
