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
    end,
  },
}
