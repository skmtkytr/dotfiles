local Util = require("util")

return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
  },
  {
    "glepnir/lspsaga.nvim",
    event = { "LspAttach" },
    config = function()
      require('lspsaga').setup({})
    end
  },
  {
    'williamboman/mason.nvim',
    cmd = "Mason",
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require('mason-lspconfig').setup_handlers({ function(server)
        local opt = {
          -- -- Function executed when the LSP server startup
          -- on_attach = function(client, bufnr)
            -- if client.server_capabilities.documentFormattingProvider then
            --   vim.cmd(
            --     [[
            --  augroup LspFormatting
            --  autocmd! * <buffer>
            --  autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            --  augroup END
            --  ]]
            --   )
            -- end
            -- vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil,1000)'
          -- end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }
        opt.capabilities.textDocument.completion.completionItem.snippetSupport = false
        require('lspconfig')[server].setup(opt)
        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'vim' },
              },
            },
          }
        })

        lspconfig.typeprof.setup({
          capabilities = opt.capabilities,
          -- on_attach = on_attach,
          on_new_config = function(config, root_dir)
            config.cmd = { "bundle", "exec", "typeprof" }
            return config
          end,
        })

        lspconfig.rubocop.setup({
          calabilities = opt.capabilities,
          on_new_config = function(config, root_dir)
            config.cmd = { "bundle", "exec", "rubocop" }
            return config
          end
        })

        -- SteepのLanguage Serverを起動するための設定
        -- デフォルトの設定をいくつか上書きしている
        lspconfig.steep.setup({
          -- 補完に対応したcapabilitiesを渡す
          capabilities = opt.capabilities,
          on_attach = function(client, bufnr)
            -- LSP関連のキーマップの基本定義
            -- on_attach(client, bufnr)
            -- Steepで型チェックを再実行するためのキーマップ定義
            vim.keymap.set("n", "<space>ct", function()
              client.request("$/typecheck", { guid = "typecheck-" .. os.time() }, function()
              end, bufnr)
            end, { silent = true, buffer = bufnr })
          end,
          on_new_config = function(config, root_dir)
            config.cmd = { "bundle", "exec", "steep", "langserver" }
            return config
          end,
        })
      end
      })
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local null_ls = require "null-ls"
      null_ls.setup({
        capabilities = capabilities,
        sources = {
          null_ls.builtins.completion.luasnip,
          null_ls.builtins.formatting.stylua.with({
            condition = function(utils)
              return utils.root_has_file({ ".stylua.toml" })
            end,
          }),
          -- null_ls.builtins.diagnostics.rubocop,
          -- null_ls.builtins.diagnostics.rubocop.with({
          --   prefer_local = "bundle_bin",
          --   condition = function(utils)
          --     return utils.root_has_file({ ".rubocop.yml" })
          --   end,
          -- }),
          -- null_ls.builtins.diagnostics.luacheck.with({
          --   extra_args = { "--globals", "vim", "--globals", "awesome" },
          -- }),
          -- null_ls.builtins.diagnostics.yamllint,
          null_ls.builtins.diagnostics.commitlint,
          null_ls.builtins.formatting.rubyfmt,
          -- null_ls.builtins.formatting.rubocop,
          -- null_ls.builtins.formatting.rubocop.with({
          --   prefer_local = "bundle_bin",
          --   condition = function(utils)
          --     return utils.root_has_file({ ".rubocop.yml" })
          --   end,
          -- }),
          null_ls.builtins.completion.spell,
        },
      })
    end
  },


  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --   },
  --   config = function()
  --     require("mason-null-ls").setup({
  --       ensure_installed = {
  --         -- Opt to list sources here, when available in mason.
  --       },
  --       automatic_installation = false,
  --       handlers = {},
  --     })
  --   end,
  -- },
  --
  -- LSP diagnostics UI plugins
  -- ({
  --   "folke/trouble.nvim",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   config = function()
  --     require("trouble").setup({
  --       auto_close = true,
  --     })
  --
  --     local wk = require "which-key"
  --     wk.register({
  --       ["<leader>x"] = {
  --         name = "+Trouble",
  --       },
  --     })
  --     vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xw",
  --       "<cmd>TroubleToggle workspace_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap(
  --       "n",
  --       "<leader>xd",
  --       "<cmd>TroubleToggle document_diagnostics<cr>",
  --       { silent = true, noremap = true }
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
  --     vim.api.nvim_set_keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
  --   end,
  -- })
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = { "LspAttach" },
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      require("fidget").setup {}
    end
  },

}
