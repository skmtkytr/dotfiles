-- ruby settings

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ruby",
      })
    end,
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, {
  --       "solargraph",
  --     })
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "suketa/nvim-dap-ruby",
      config = function()
        require("dap-ruby").setup()
      end,
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "olimorris/neotest-rspec",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            local result = vim.fs.find("docker-compose.yml")
            if #result ~= 0 then
              return vim.tbl_flatten({
                -- docker compose run --rm rails bundle exec rspec
                "docker",
                "compose",
                "run",
                "--rm",
                "rails",
                "bundle",
                "exec",
                "rspec",
              })
            else
              return vim.tbl_flatten({
                "bundle",
                "exec",
                "rspec",
              })
            end
          end,

          transform_spec_path = function(path)
            local prefix = require("neotest-rspec").root(path)
            return string.sub(path, string.len(prefix) + 2, -1)
          end,

          results_path = "tmp/rspec.output",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {},
        steep = {
          on_attach = function(client, bufnr)
            -- LSP関連のキーマップの基本定義
            -- on_attach(client, bufnr)
            -- Steepで型チェックを再実行するためのキーマップ定義
            vim.keymap.set("n", "<space>ct", function()
              client.request("$/typecheck", { guid = "typecheck-" .. os.time() }, function() end, bufnr)
            end, { silent = true, buffer = bufnr })
          end,
        },
      },
    },
  },
}