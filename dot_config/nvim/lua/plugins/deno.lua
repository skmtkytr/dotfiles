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

      local util = require("lspconfig.util")
      local is_node_dir = function()
        return util.root_pattern("package.json")(vim.fn.getcwd())
      end

      opts.servers.denols = {
        root_dir = util.root_pattern("deno.json", "deno.jsonc", "deno.lock", "deno.lock.json"),
        init_options = {
          lint = true,
          unstable = true,
        },
        on_attach = function(client)
          if is_node_dir() then
            client.stop(true)
          end
        end,
      }

      opts.servers.ts_ls = opts.servers.ts_ls or {}
      local prev_on_attach = opts.servers.ts_ls.on_attach
      opts.servers.ts_ls.on_attach = function(client, bufnr)
        if not is_node_dir() then
          client.stop(true)
          return
        end
        if prev_on_attach then
          prev_on_attach(client, bufnr)
        end
      end
    end,
  },
}
