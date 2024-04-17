-- ui settings

return {

  -- edgy settings
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      -- local edgy_idx = LazyVim.plugin.extra_idx("ui.edgy")
      -- local symbols_idx = LazyVim.plugin.extra_idx("editor.outline")
      --
      -- if edgy_idx and edgy_idx > symbols_idx then
      --   LazyVim.warn(
      --     "The `edgy.nvim` extra must be **imported** before the `outline.nvim` extra to work properly.",
      --     { title = "LazyVim" }
      --   )
      -- end
      opts.left = opts.left or {}
      table.remove(opts.left, 2)

      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Neotest Summary",
        ft = "neotest-summary",
      })

      opts.options = opts.options or {}
      opts.options["left"] = { size = 45 }
      opts.options["buttom"] = { size = 10 }
      opts.options["right"] = { size = 45 }
      opts.options["top"] = { size = 10 }
      -- table.insert(opts.options.left, {
      --   size = 50,
      -- })
      -- table.insert(opts.options.buttom, {
      --   size = 10,
      -- })
      -- table.insert(opts.options.right, {
      --   size = 50,
      -- })
      -- table.insert(opts.options.top, {
      --   size = 10,
      -- })

      print(vim.inspect(opts.options))
    end,
  },

  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Fzflua",
    keys = {
      { "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true } },
      { ";cb", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { silent = true } },
      { ";f", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      { "<leader>/", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      { ";cf", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true } },
      { "<C-O>", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true } },
      { ";gst", "<cmd>lua require('fzf-lua').git_status()<CR>", { silent = true } },
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        { "telescope" },
        files = {
          fd_opts = "-I --color=never --type f --hidden --follow --exclude .git",
        },
        -- fzf_opts = function()
        --   local opts = { ["--no-separator"] = false }
        --   return opts
        -- end,
      })
    end,
  },
}
