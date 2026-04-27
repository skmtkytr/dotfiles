return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.filetype.add({ extension = { mbt = "moonbit" } })
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").moonbit = {
            install_info = {
              url = "https://github.com/moonbitlang/tree-sitter-moonbit",
              revision = "82237f3f508d09fb09668d9885c99a562a756fe0",
              queries = "queries",
            },
            tier = 3,
          }
        end,
      })
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" then
        table.insert(opts.ensure_installed, "moonbit")
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        moonbit_lsp = {
          cmd = { "moonbit-lsp" },
          filetypes = { "moonbit" },
          root_markers = { "moon.mod.json", ".git" },
        },
      },
      setup = {
        moonbit_lsp = function(_, opts)
          vim.lsp.config("moonbit_lsp", opts)
          vim.lsp.enable("moonbit_lsp")
          return true
        end,
      },
    },
  },
}
