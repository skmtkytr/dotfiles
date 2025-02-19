-- ruby settings

return {
  { "jlcrochet/vim-rbs", ft = "rbs" },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "RRethy/nvim-treesitter-endwise" },
    },
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ruby",
      })

      opts["endwise"] = { enable = true }
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
    keys = {
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach test",
      },
    },
    optional = true,
    dependencies = {
      "olimorris/neotest-rspec",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            local cw = vim.fs.find("dev-tools")
            local docker = vim.fs.find("docker-compose.yml")

            if #cw ~= 0 then
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
            elseif #docker ~= 0 then
              return vim.tbl_flatten({
                -- docker compose run --rm app bundle exec rspec
                "docker",
                "compose",
                "run",
                "--rm",
                "app",
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

          formatter = "json",

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
        ruby_lsp = {
          mason = false,
        },
        -- rubocop = {
        --   mason = false,
        --   cmd = {
        --     -- "docker",
        --     -- "compose",
        --     -- "run",
        --     -- "--rm",
        --     -- "rails",
        --     -- "bundle",
        --     -- "exec",
        --     "rubocop",
        --     "--lsp",
        --   },
        -- },
        -- steep = {
        --   on_attach = function(client, bufnr)
        --     -- LSP関連のキーマップの基本定義
        --     -- on_attach(client, bufnr)
        --     -- Steepで型チェックを再実行するためのキーマップ定義
        --     vim.keymap.set("n", "<space>ct", function()
        --       client.request("$/typecheck", { guid = "typecheck-" .. os.time() }, function() end, bufnr)
        --     end, { silent = true, buffer = bufnr })
        --   end,
        -- },
      },
      -- setup = {
      --   ruby_lsp = function(_, opts)
      --     on_attach = function(client, _)
      --       if client.name == "ruby_lsp" then
      --         if not client.server_capabilities.semanticTokensProvider then
      --           local semantic = client.config.capabilities.textDocument.semanticTokens
      --           client.server_capabilities.semanticTokensProvider = nil
      --           -- client.server_capabilities.semanticTokensProvider = {
      --           --   full = true,
      --           --   legend = {
      --           --     tokenTypes = semantic.tokenTypes,
      --           --     tokenModifiers = semantic.tokenModifiers,
      --           --   },
      --           --   range = true,
      --           -- }
      --         end
      --       end
      --     end
      --   end,
      -- },
    },
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   opts = function(_, opts)
  --     local nls = require("null-ls")
  --     opts.root_dir = opts.root_dir
  --       or require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
  --     opts.sources = vim.list_extend(opts.sources or {}, {
  --       nls.builtins.diagnostics.rubocop,
  --       -- nls.builtins.formatting.rubyfmt,
  --     })
  --   end,
  -- },
}
