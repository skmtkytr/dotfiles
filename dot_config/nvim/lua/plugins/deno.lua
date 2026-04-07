-- deno plugin
return {

  { "sigmasd/deno-nvim", lazy = true },
  { "vim-denops/denops.vim", lazy = true },

  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "deno")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.denols = {
        root_dir = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc", "deno.lock", "deno.lock.json"),
        init_options = {
          lint = true,
          unstable = true,
        },
      }
      local nvim_lsp = require("lspconfig")
      local is_node_dir = function()
        return nvim_lsp.util.root_pattern("package.json")(vim.fn.getcwd())
      end

      -- ts_ls
      local ts_opts = {}
      ts_opts.on_attach = function(client)
        if not is_node_dir() then
          client.stop(true)
        end
      end
      nvim_lsp.ts_ls.setup(ts_opts)

      -- denols
      local deno_opts = {}
      deno_opts.on_attach = function(client)
        if is_node_dir() then
          client.stop(true)
        end
      end
      nvim_lsp.denols.setup(deno_opts)
    end,
  },
}
