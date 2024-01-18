-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({

  -- Install your plugins here
  {
    "dstein64/vim-startuptime",
    -- lazy-load on a command
    cmd = "StartupTime",
    -- init is called during startup. Configuration for vim plugins typically should be set in an init function
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- My plugins here

  { "nvim-lua/plenary.nvim" }, -- Common utilities
  { "tpope/vim-surround" },
  {
    "folke/which-key.nvim",
    keys = {
      { "<F3>",       "<cmd>OtherClear<CR><cmd>:Other<CR>" },
      { "<leader>os", "<cmd>OtherClear<CR><cmd>:OtherSplit<CR>" },
      { "<leader>ov", "<cmd>OtherClear<CR><cmd>:OtherVSplit<CR>" },
    },
    config = function()
      local wk = require "which-key"
      wk.register({
        ["<leader>o"] = {
          name = "+Other",
        },
      })
    end
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = { "InsertEnter", "BufRead", "BufNewFile" },
    dependencies = {
      { "nvim-tree/nvim-web-devicons", },
    },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { "dashboard", "lazy", "alpha" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { 'filename' },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },

  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function() require("nvim-autopairs").setup {} end
  }, -- Autopairs,integrates with both cmp and treesitter
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require 'nvim-web-devicons'.setup {
        -- your personnal icons can go here (to override)
        -- you can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        override = {
        },
        -- globally enable different highlight colors per icon (default to true)
        -- if set to false all icons will have the default icon's color
        color_icons = true,
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true,
        -- globally enable "strict" selection of icons - icon will be looked up in
        -- different tables, first by filename, and if not found by extension; this
        -- prevents cases when file doesn't have any extension but still gets some icon
        -- because its name happened to match some extension (default to false)
        strict = true,
        -- same as `override` but specifically for overrides by filename
        -- takes effect when `strict` is true
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        },
        -- same as `override` but specifically for overrides by extension
        -- takes effect when `strict` is true
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        },
      }
    end
  },                                                       -- File icons
  { "mattn/vim-lsp-icons",                 lazy = true, }, -- File icons

  -- Github copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    ft = {
      "go", "typescript", "typescriptreact", "javascript", "javascriptreact", "lua", "rust", "python",
      "ruby", "elixir", "php", "java", "c", "cpp", "cs", "scala", "swift", "kotlin", "dart", "haskell",
    },
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  -- {
  --   "zbirenbaum/copilot-cmp",
  --   event = { "InsertEnter" },
  --   config = function()
  --     require("copilot_cmp").setup()
  --   end
  -- },

  -- cmp plugins
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      { "hrsh7th/cmp-buffer",                  event = { "InsertEnter" } },
      { "hrsh7th/cmp-path",                    event = { "InsertEnter" } },
      { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
      { "saadparwaiz1/cmp_luasnip",            event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lsp",                event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lua",                event = { "InsertEnter" } },
      { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lsp-signature-help", event = { "InsertEnter" } },
      { "onsails/lspkind-nvim",                event = "InsertEnter" },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end
      },
    },
    config = function()
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
      local cmp = require "cmp"
      local lspkind = require('lspkind')
      cmp.setup({
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
          { name = "cmdline" },
          { name = "nvim_lsp_signature_help" },
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            symbol_map = { Copilot = "" },

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              return vim_item
            end
          })
        }
      })
    end
  },
  { "hrsh7th/cmp-buffer",                  event = { "InsertEnter" } },
  { "hrsh7th/cmp-path",                    event = { "InsertEnter" } },
  { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
  { "saadparwaiz1/cmp_luasnip",            event = { "InsertEnter" } },
  { "hrsh7th/cmp-nvim-lsp",                event = { "InsertEnter" } },
  { "hrsh7th/cmp-nvim-lua",                event = { "InsertEnter" } },
  { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = { "InsertEnter" } },
  { "onsails/lspkind-nvim",                event = "InsertEnter" },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    config = function()
      require("fidget").setup {}
    end
  },

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    build = "make install_jsregexp"
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
  }, -- enable LSP

  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "LspAttach" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        'MunifTanjim/prettier.nvim',
        event = { "LspAttach" },
        config = function()
          local prettier = require("prettier")

          prettier.setup({
            ["null-ls"] = {
              condition = function()
                return prettier.config_exists({
                  -- if `false`, skips checking `package.json` for `"prettier"` key
                  check_package_json = true,
                })
              end,
              runtime_condition = function(params)
                -- return false to skip running prettier
                return true
              end,
              timeout = 5000,
            }
          })
        end
      },
    },
    config = function()
      local null_ls = require "null-ls"
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local cspell_append = function(opts)
        local word = opts.args
        if not word or word == "" then
          -- 引数がなければcwordを取得
          word = vim.call('expand', '<cword>'):lower()
        end

        -- bangの有無で保存先を分岐
        local dictionary_name = opts.bang and 'dotfiles' or 'user'
        local dictionary_path = opts.bang and cspell_files.dotfiles or cspell_files.user

        -- shellのechoコマンドで辞書ファイルに追記
        io.popen('echo ' .. word .. ' >> ' .. dictionary_path)

        -- 追加した単語および辞書を表示
        vim.notify(
          '"' .. word .. '" is appended to ' .. dictionary_name .. ' dictionary.',
          vim.log.levels.INFO,
          {}
        )

        -- cspellをリロードするため、現在行を更新してすぐ戻す
        if vim.api.nvim_get_option_value('modifiable', {}) then
          vim.api.nvim_set_current_line(vim.api.nvim_get_current_line())
          vim.api.nvim_command('silent! undo')
        end
      end

      vim.api.nvim_create_user_command(
        'CSpellAppend',
        cspell_append,
        { nargs = '?', bang = true }
      )

      -- $XDG_CONFIG_HOME/cspell
      local cspell_config_dir = '~/.config/cspell'
      -- $XDG_DATA_HOME/cspell
      local cspell_data_dir = '~/.local/share/cspell'
      cspell_files = {
        config = vim.call('expand', cspell_config_dir .. '/cspell.json'),
        dotfiles = vim.call('expand', cspell_config_dir .. '/dotfiles.txt'),
        vim = vim.call('expand', cspell_data_dir .. '/vim.txt.gz'),
        user = vim.call('expand', cspell_data_dir .. '/user.txt'),
      }

      -- vim辞書がなければダウンロード
      if vim.fn.filereadable(cspell_files.vim) ~= 1 then
        local vim_dictionary_url = 'https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz'
        io.popen('curl -fsSLo ' .. cspell_files.vim .. ' --create-dirs ' .. vim_dictionary_url)
      end

      -- ユーザー辞書がなければ作成
      if vim.fn.filereadable(cspell_files.user) ~= 1 then
        io.popen('mkdir -p ' .. cspell_data_dir)
        io.popen('touch ' .. cspell_files.user)
      end

      null_ls.setup({
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            -- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
            --   buffer = bufnr,
            --   group = group,
            --   callback = function()
            --     vim.lsp.buf.format({ bufnr = bufnr, async = async })
            --   end,
            --   desc = "[lsp] format on save",
            -- })
          end

          if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
          end
        end,

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
          -- null_ls.builtins.diagnostics.commitlint,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.rubyfmt,
          null_ls.builtins.formatting.deno_fmt.with {
            condition = function(utils)
              return not (utils.has_file { ".prettierrc", ".prettierrc.js", "deno.json", "deno.jsonc" })
            end,
          },
          null_ls.builtins.formatting.prettier.with {
            condition = function(utils)
              return utils.has_file { ".prettierrc", ".prettierrc.js" }
            end,
            prefer_local = "node_modules/.bin",
          },
          -- null_ls.builtins.formatting.rubocop,
          -- null_ls.builtins.formatting.rubocop.with({
          --   prefer_local = "bundle_bin",
          --   condition = function(utils)
          --     return utils.root_has_file({ ".rubocop.yml" })
          --   end,
          -- }),
          --
          -- null_ls.builtins.diagnostics.codespell,
          -- null_ls.builtins.completion.spell,
          -- null_ls.builtins.diagnostics.cspell.with({
          --   diagnostics_postprocess = function(diagnostic)
          --     -- レベルをWARNに変更（デフォルトはERROR）
          --     diagnostic.severity = vim.diagnostic.severity["WARN"]
          --     -- 起動時に設定ファイル読み込み
          --     extra_args = { '--config', cspell_files.config }
          --   end,
          --   condition = function()
          --     -- cspellが実行できるときのみ有効
          --     return vim.fn.executable('cspell') > 0
          --   end
          -- })

        },
      })

      local cspell_custom_actions = {
        name = 'append-to-cspell-dictionary',
        method = null_ls.methods.CODE_ACTION,
        filetypes = {},
        generator = {
          fn = function(_)
            -- 現在のカーソル位置
            local lnum = vim.fn.getcurpos()[2] - 1
            local col = vim.fn.getcurpos()[3]

            -- 現在行のエラーメッセージ一覧
            local diagnostics = vim.diagnostic.get(0, { lnum = lnum })

            -- カーソル位置にcspellの警告が出ているか探索
            local word = ''
            local regex = '^Unknown word %((%w+)%)$'
            for _, v in pairs(diagnostics) do
              if v.source == "cspell" and
                  v.col < col and col <= v.end_col and
                  string.match(v.message, regex) then
                -- 見つかった場合、単語を抽出
                word = string.gsub(v.message, regex, '%1'):lower()
                break
              end
            end

            -- 警告が見つからなければ終了
            if word == '' then
              return
            end

            -- cspell_appendを呼び出すactionのリストを返却
            return {
              {
                title = 'Append "' .. word .. '" to user dictionary',
                action = function()
                  cspell_append({ args = word })
                end
              },
              {
                title = 'Append "' .. word .. '" to dotfiles dictionary',
                action = function()
                  cspell_append({ args = word, bang = true })
                end
              }
            }
          end
        }
      }

      -- null_lsに登録
      -- null_ls.register(cspell_custom_actions)
    end
  },

  {
    "glepnir/lspsaga.nvim",
    event = { "LspAttach" },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('lspsaga').setup()
    end
  }, -- LSP UIs
  --  { "prabirshrestha/vim-lsp" }, -- LSP
  --  { 'mattn/vim-lsp-settings' }, -- LSP suggest installer
  {
    'williamboman/mason.nvim',
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
      "MasonUpdate",
    },
    -- event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('mason').setup()
    end
  },

  {
    'williamboman/mason-lspconfig.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('mason-lspconfig').setup_handlers({ function(server)
        local opt = {
          -- -- Function executed when the LSP server startup
          -- on_attach = function(client, bufnr)
          --   if client.server_capabilities.documentFormattingProvider then
          --  vim.cmd(
          --    [[
          -- augroup LspFormatting
          -- autocmd! * <buffer>
          -- autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
          -- augroup END
          -- ]]
          --  )
          -- end
          -- vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil,1000)'
          -- end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }
        -- opt.capabilities.textDocument.completion.completionItem.snippetSupport = false
        require('lspconfig')[server].setup(opt)
        local lspconfig = require("lspconfig")

        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
            },
          }
        })

        lspconfig.eslint.setup({
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        })

        -- lspconfig.typeprof.setup({
        --   capabilities = opt.capabilities,
        --   -- on_attach = on_attach,
        --   on_new_config = function(config, root_dir)
        --     config.cmd = { "bundle", "exec", "typeprof" }
        --     return config
        --   end,
        -- })
        lspconfig.gopls.setup {}

        -- lspconfig.rubocop.setup({
        --   calabilities = opt.capabilities,
        --   on_new_config = function(config, root_dir)
        --     config.cmd = { "bundle", "exec", "rubocop" }
        --     return config
        --   end
        -- })
        lspconfig.solargraph.setup({})

        -- SteepのLanguage Serverを起動するための設定
        -- デフォルトの設定をいくつか上書きしている
        lspconfig.steep.setup({
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
        })
        -- lspconfig.steep.setup({
        --   -- 補完に対応したcapabilitiesを渡す
        --   capabilities = opt.capabilities,
        --   on_attach = function(client, bufnr)
        --     -- LSP関連のキーマップの基本定義
        --     -- on_attach(client, bufnr)
        --     -- Steepで型チェックを再実行するためのキーマップ定義
        --     vim.keymap.set("n", "<space>ct", function()
        --       client.request("$/typecheck", { guid = "typecheck-" .. os.time() }, function()
        --       end, bufnr)
        --     end, { silent = true, buffer = bufnr })
        --   end,
        --   on_new_config = function(config, root_dir)
        --     config.cmd = { "bundle", "exec", "steep", "langserver" }
        --     return config
        --   end,
        -- })
      end
      })
    end
  },

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
    event = "LspAttach",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  },


  -- other.vim
  {
    'rgroli/other.nvim',
    cmd = { "Other", "OtherClear" },
    config = function()
      rails_controller_patterns = {
        { target = "/spec/controllers/%1_spec.rb", context = "spec" },
        { target = "/spec/requests/%1_spec.rb",    context = "spec" },
        { target = "/spec/factories/%1.rb",        context = "factories", transformer = "singularize" },
        { target = "/app/models/%1.rb",            context = "models",    transformer = "singularize" },
        { target = "/app/views/%1/**/*.html.*",    context = "view" },
      }
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          "rails",
          -- "golang",
          -- custom mapping
          {
            pattern = "/app/models/(.*).rb",
            target = {
              { target = "/spec/models/%1_spec.rb",              context = "spec" },
              { target = "/spec/factories/%1.rb",                context = "factories",  transformer = "pluralize" },
              { target = "/app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
              { target = "/app/views/%1/**/*.html.*",            context = "view",       transformer = "pluralize" },
            },
          },
          {
            pattern = "/spec/models/(.*)_spec.rb",
            target = {
              { target = "/app/models/%1.rb", context = "models" },
            },
          },
          {
            pattern = "/spec/factories/(.*).rb",
            target = {
              { target = "/app/models/%1.rb",       context = "models", transformer = "singularize" },
              { target = "/spec/models/%1_spec.rb", context = "spec",   transformer = "singularize" },
            },
          },
          {
            pattern = "/app/services/(.*).rb",
            target = {
              { target = "/spec/services/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "/spec/services/(.*)_spec.rb",
            target = {
              { target = "/app/services/%1.rb", context = "services" },
            },
          },
          {
            pattern = "/app/controllers/.*/(.*)_controller.rb",
            target = rails_controller_patterns,
          },
          {
            pattern = "/app/controllers/(.*)_controller.rb",
            target = rails_controller_patterns,
          },
          {
            pattern = "/app/views/(.*)/.*.html.*",
            target = {
              { target = "/spec/factories/%1.rb",                context = "factories",  transformer = "singularize" },
              { target = "/app/models/%1.rb",                    context = "models",     transformer = "singularize" },
              { target = "/app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
            },
          },
          {
            pattern = "/app/contexts/(.*).rb$",
            target = {
              { target = "/app/contexts/%1.rbs",      context = "sig" },
              { target = "/spec/contexts/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "/app/contexts/(.*).rbs$",
            target = {
              { target = "/app/contexts/%1.rb",       context = "app" },
              { target = "/spec/contexts/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "/lib/(.*)/(.*).rb",
            target = {
              { target = "/spec/%1_spec.rb", context = "spec" },
              { target = "/sig/%1.rbs",      context = "sig" },
            },
          },
          {
            pattern = "/sig/.*/(.*).rbs",
            target = {
              { target = "/lib/%1.rb", context = "lib" },
              { target = "/%1.rb" },
            },
          },
          {
            pattern = "/spec/.*/(.*)_spec.rb",
            target = {
              { target = "/app/%1.rb",  context = "app" },
              { target = "/lib/%1.rb",  context = "lib" },
              { target = "/sig/%1.rbs", context = "sig" },
            },
          },
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function(inputString)
            return inputString:lower()
          end
        },
        style = {
          -- How the plugin paints its window borders
          -- Allowed values are none,single, double, rounded, solid and shadow
          border = "solid",

          -- Column seperator for the window
          seperator = "|",

          -- width of the window in percent. e.g. 0.5 is 50%,1.0 is 100%
          width = 0.7,

          -- min height in rows.
          -- when more columns are needed this value is extended automatically
          minHeight = 2
        }
      })
    end
  },

  -- motion
  {
    'phaazon/hop.nvim',
    event = { "BufRead", "BufNewFile" },
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  -- Formatter
  { "MunifTanjim/prettier.nvim" },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        cmd = 'Telescope',
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        cmd = 'Telescope',
        keys = {
          -- { ';cb', ":Telescope frecency workspace=CWD<CR>" },
        },
        config = function()
          require("telescope").load_extension("frecency")
        end,
        dependencies = { "kkharji/sqlite.lua" }
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = 'make',
        config = function()
          require('telescope').load_extension('fzf')
        end
      },
      {
        "nvim-telescope/telescope-fzf-writer.nvim",
        config = function()
          require('telescope').load_extension('fzf_writer')
        end
      },
    },
    cmd = 'Telescope',
    keys = {
      -- { '<C-p>',    ':Telescope find_files find_command=rg,--files,--hidden,--ignore,--glob,!*.git <CR>' },
      -- { '<Space>f', ':Telescope live_grep<CR>' },
      -- { ';cf',      ':Telescope grep_string<CR>' },
      -- { '<C-O>',    ':Telescope lsp_document_symbols<CR>' },
      -- { ';gst',     ':Telescope git_status<CR>' },
    },
    config = function()
      require('telescope').load_extension('frecency')
      require('telescope').load_extension('fzf')
      require('telescope').setup {
        defaults = {
          leyout_config        = {
            vertical       = {
              width = 0.9,
              height = 0.95,
              preview_height = 0.5,
            },
            -- file_sorter            = require('telescope.sorters').get_fzy_sorter,
            color_devicons = true,

            -- file_previewer         = require('telescope.previewers').vim_buffer_cat.new,
            -- grep_previewer         = require('telescope.previewers').vim_buffer_vimgrep.new,
            -- list_previewer       = require('telescope.previewers').vim_buffer_qflist.new,
            -- buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker
          },
          prompt_prefix        = "   ",
          selection_caret      = "  ",
          sorting_strategy     = "ascending",
          file_ignore_patterns = {
            ".git/",
            "target/",
            "docs/",
            "vendor/*",
            "%.lock",
            "__pycache__/*",
            "%.sqlite3",
            "%.ipynb",
            "node_modules/*",
            -- "%.jpg",
            -- "%.jpeg",
            -- "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
            "%.webp",
            ".dart_tool/",
            ".github/",
            ".gradle/",
            ".idea/",
            ".settings/",
            ".vscode/",
            "__pycache__/",
            "build/",
            "gradle/",
            "node_modules/",
            "%.pdb",
            "%.dll",
            "%.class",
            "%.exe",
            "%.cache",
            "%.ico",
            "%.pdf",
            "%.dylib",
            "%.jar",
            "%.docx",
            "%.met",
            "smalljre_*/*",
            ".vale/",
            "%.burp",
            "%.mp4",
            "%.mkv",
            "%.rar",
            "%.zip",
            "%.7z",
            "%.tar",
            "%.bz2",
            ".epub",
            "%.flac",
            "%.tar.gz",
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            layout_config = {
              width = 0.9,
            },
            ignore_patterns = { "node_modules", "vendor", "tmp" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          fzf_writer = {
            minimum_grep_characters = 2,
            minimum_files_characters = 2,

            -- Disabled by default.
            -- Will probably slow down some aspects of the sorter, but can make color highlights.
            -- I will work on this more later.
            use_highlighter = true,
          },
          frecency = {
            show_scores = false,
            show_unindexed = false,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            disable_devicons = false,
          }
        },
      }
    end
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = 'Fzflua',
    keys = {
      { '<C-p>',    '<cmd>lua require(\'fzf-lua\').files()<CR>',                { silent = true } },
      { ';cb',      '<cmd>lua require(\'fzf-lua\').oldfiles()<CR>',             { silent = true } },
      { '<Space>f', '<cmd>lua require(\'fzf-lua\').live_grep_native()<CR>',     { silent = true } },
      { ';cf',      '<cmd>lua require(\'fzf-lua\').grep_cword()<CR>',           { silent = true } },
      { '<C-O>',    '<cmd>lua require(\'fzf-lua\').lsp_document_symbols()<CR>', { silent = true } },
      { ';gst',     '<cmd>lua require(\'fzf-lua\').git_status()<CR>',           { silent = true } },
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        'telescope',
        files = {
          fd_opts = "-I --color=never --type f --hidden --follow --exclude .git",
        }
      })
    end
  },


  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
    },
    event = { "BufReadPost", "BufNewFile" },
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        highlight = {
          enable = true, -- false will disable the whole extension
        },
        incremental_selection = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        endwise = {
          enable = true,
        }, -- Install parsers synchronously (only applied to `ensure_installed`)
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
          "lua",
          "ruby",
          "go",
          "javascript",
          "typescript",
          "tsx",
          "html",
        }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,

        -- List of parsers to ignore installing (for "all")
        ignore_install = { "javascript" },

        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
      }
    end,
  },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },
  -- { "windwp/nvim-ts-autotag",         lazy = true },
  -- { "RRethy/nvim-treesitter-endwise", lazy = true },

  -- comment outer
  {
    "skmtkytr/caw.vim",
    event = { "BufRead", "BufNewFile" },
  },

  -- git commit outline
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufRead" },
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          follow_files = true
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text = true,
          virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 6,
        update_debounce              = 100,
        status_formatter             = nil,   -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1
        },
        yadm                         = {
          enable = false
        },
        on_attach                    = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { expr = true })

          -- Actions
          map('n', '<leader>hs', gs.stage_hunk)
          map('n', '<leader>hr', gs.reset_hunk)
          map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line { full = true } end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end
  },
  { "tpope/vim-fugitive", cmd = "Git" },

  {
    "petertriho/nvim-scrollbar",
    event = {
      "BufWinEnter",
      "CmdwinLeave",
      "TabEnter",
      "TermEnter",
      "TextChanged",
      "VimResized",
      "WinEnter",
      "WinScrolled",
    },
    config = function()
      require("scrollbar").setup {}
    end,
  },
  --  {
  --   'kdheepak/tabline.nvim',
  --   config = function()
  --     require 'tabline'.setup {
  --       -- Defaults configuration options
  --       enable = true,
  --       options = {
  --         -- If lualine is installed tabline will use separators configured in lualine by default.
  --         -- These options can be used to override those settings.
  --         section_separators = { '', '' },
  --         component_separators = { '', '' },
  --         max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
  --         show_tabs_always = false,  -- this shows tabs only when there are more than one tab or if the first tab is named
  --         show_devicons = true,      -- this shows devicons in buffer section
  --         show_bufnr = false,        -- this appends [bufnr] to buffer section,
  --         show_filename_only = false, -- shows base filename only instead of relative path in filename
  --         modified_icon = "+ ",      -- change the default modified icon
  --         modified_italic = false,   -- set to true by default; this determines whether the filename turns italic if modified
  --         show_tabs_only = false,    -- this shows only tabs instead of tabs + buffers
  --       }
  --     }
  --     vim.cmd [[
  --     set guioptions-=e " Use showtabline in gui vim
  --     set sessionoptions+=tabpages,globals " store tabpages and globals in session
  --   ]]
  --   end,
  --   dependencies = { { 'hoob3rt/lualine.nvim', lazy = true }, { 'kyazdani42/nvim-web-devicons', lazy = true } }
  -- }



  -- Intent showable
  --  {
  --   "echasnovski/mini.indentscope",
  --   branch = 'stable',
  --   config = function()
  --     require('mini.indentscope').setup()
  --   end
  -- }
  --  {
  --   "preservim/vim-indent-guides",
  --   config = function()
  --     vim.g.indent_guides_enable_on_vim_startup = 1
  --     vim.g.indent_guides_start_level = 2
  --     vim.g.indent_guides_guide_size = 1
  --     vim.g.indent_guides_exclude_filetypes = { 'help', 'nerdtree', 'tagbar', 'unite' }
  --   end
  -- }
  {
    "lukas-reineke/indent-blankline.nvim",
    tag = 'v2.20.8',
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append "space:⋅"
      vim.opt.listchars:append "eol:↴"

      require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  },

  -- Transparent opacity
  -- {
  --   'xiyaowong/transparent.nvim',
  --   config = function()
  --     require("transparent").setup({
  --       groups = { -- table: default groups
  --         'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
  --         'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
  --         'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
  --         'SignColumn', 'CursorLineNr', 'EndOfBuffer',
  --       },
  --       extra_groups = {},   -- table: additional groups that should be cleared
  --       exclude_groups = {}, -- table: groups you don't want to clear
  --     })
  --   end
  -- },

  -- File browser
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        version = '2.*',
        config = function()
          require 'window-picker'.setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" },
              },
            },
            other_win_hl_color = '#e35e4f',
          })
        end,
      }
    },
    config = function()
      require("neo-tree").setup({
        sources = {
          "filesystem",
          "buffers",
          "git_status",
          "document_symbols",
        },
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              "node_modules",
              "vendor"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              ".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = true,          -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
        },
      })
    end
  },
  -- {
  --   'nvim-tree/nvim-tree.lua',
  --   dependencies = {
  --     'nvim-tree/nvim-web-devicons', -- optional
  --   },
  --   keys = {
  --     { '<M-w>',  ':NvimTreeToggle<CR>' },
  --     { '<C-j>w', ':NvimTreeFindFile<CR>' }
  --   },
  --   config = function()
  --     -- OR setup with some options
  --     require("nvim-tree").setup({
  --       sort_by = "case_sensitive",
  --       view = {
  --         width = 30,
  --       },
  --       renderer = {
  --         group_empty = true,
  --       },
  --       filters = {
  --         dotfiles = true,
  --       },
  --     })
  --   end
  -- },

  -- Ruby plugins
  { 'vim-ruby/vim-ruby',  ft = "rb" },
  --  { 'tpope/vim-rails' },

  -- filetype plugins
  { 'jlcrochet/vim-rbs',  ft = "rbs" },
  --  { "keith/rspec.vim", ft = "rb" }

  -- Colorschemes
  --  "sainnhe/sonokai",
  -- {
  --   "EdenEast/nightfox.nvim",
  --   config = function()
  --     -- Default options
  --     require('nightfox').setup({
  --       options = {
  --         -- Compiled file's destination location
  --         compile_path = vim.fn.stdpath("cache") .. "/nightfox",
  --         compile_file_suffix = "_compiled",       -- Compiled file suffix
  --         transparent = vim.g.transparent_enabled, -- Disable setting background
  --         terminal_colors = true,                  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
  --         dim_inactive = false,                    -- Non focused panes set to alternative background
  --         module_default = true,                   -- Default enable value for modules
  --         colorblind = {
  --           enable = false,                        -- Enable colorblind support
  --           simulate_only = false,                 -- Only show simulated colorblind colors and not diff shifted
  --           severity = {
  --             protan = 0,                          -- Severity [0,1] for protan (red)
  --             deutan = 0,                          -- Severity [0,1] for deutan (green)
  --             tritan = 0,                          -- Severity [0,1] for tritan (blue)
  --           },
  --         },
  --         styles = {             -- Style to be applied to different syntax groups
  --           comments = "italic", -- Value is any valid attr-list value `:help attr-list`
  --           conditionals = "NONE",
  --           constants = "NONE",
  --           functions = "NONE",
  --           keywords = "NONE",
  --           numbers = "NONE",
  --           operators = "NONE",
  --           strings = "NONE",
  --           types = "NONE",
  --           variables = "NONE",
  --         },
  --         inverse = { -- Inverse highlight for different types
  --           match_paren = false,
  --           visual = false,
  --           search = false,
  --         },
  --         modules = { -- List of various plugins and additional options
  --           -- ...
  --         },
  --       },
  --       palettes = {
  --         name = "carbonfox",
  --       },
  --       specs = {},
  --       groups = {},
  --     })
  --     -- require("nightfox.config").set_fox("duskfox")
  --     -- require("nightfox").load()
  --   end
  -- },
  --  "phanviet/vim-monokai-pro",
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   config = function()
  --     require("catppuccin").setup({
  --       compile_path = vim.fn.stdpath "cache" .. "/catppuccin",
  --       flavour = "mocha", -- latte, frappe, macchiato, mocha
  --       background = {     -- :h background
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --       transparent_background = false, -- disables setting the background color.
  --       show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
  --       term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
  --       dim_inactive = {
  --         enabled = false,              -- dims the background color of inactive window
  --         shade = "dark",
  --         percentage = 0.15,            -- percentage of the shade to apply to the inactive window
  --       },
  --       no_italic = false,              -- Force no italic
  --       no_bold = false,                -- Force no bold
  --       no_underline = false,           -- Force no underline
  --       styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
  --         comments = { "italic" },      -- Change the style of comments
  --         conditionals = { "italic" },
  --         loops = {},
  --         functions = {},
  --         keywords = {},
  --         strings = {},
  --         variables = {},
  --         numbers = {},
  --         booleans = {},
  --         properties = {},
  --         types = {},
  --         operators = {},
  --       },
  --       color_overrides = {},
  --       custom_highlights = function(c)
  --         local p = {
  --           dark2 = "#131313",
  --           dark1 = "#191919",
  --           background = "#222222",
  --           text = "#f7f1ff",
  --           accent1 = "#fc618d",
  --           accent2 = "#fd9353",
  --           accent3 = "#fce566",
  --           accent4 = "#7bd88f",
  --           accent5 = "#5ad4e6",
  --           accent6 = "#948ae3",
  --           dimmed1 = "#bab6c0",
  --           dimmed2 = "#8b888f",
  --           dimmed3 = "#69676c",
  --           dimmed4 = "#525053",
  --           dimmed5 = "#363537",
  --
  --         }
  --         c.base = {
  --           dark = p.dark2,      -- "#19181a"
  --           black = p.dark1,     --"#221f22",
  --           red = p.accent1,     -- "#ff6188",
  --           green = p.accent4,   -- "#a9dc76",
  --           yellow = p.accent3,  -- "#ffd866",
  --           blue = p.accent2,    -- "#fc9867",
  --           magenta = p.accent6, -- "#ab9df2",
  --           cyan = p.accent5,    -- "#78dce8",
  --           white = p.text,      -- "#fcfcfa",
  --           dimmed1 = p.dimmed1, -- "#c1c0c0",
  --           dimmed2 = p.dimmed2, -- "#939293",
  --           dimmed3 = p.dimmed3, -- "#727072",
  --           dimmed4 = p.dimmed4, -- "#5b595c",
  --           dimmed5 = p.dimmed5, -- "#403e41",
  --         }
  --         c.sideBar = {
  --           background = p.dark1,   -- "#221f22",
  --           foreground = p.dimmed2, -- "#939293",
  --         }
  --         c.editorSuggestWidget = {
  --           background = p.dimmed5,         -- "#403e41",
  --           border = p.dimmed5,             -- "#403e41",
  --           foreground = p.dimmed1,         -- "#c1c0c0",
  --           highlightForeground = p.text,   -- "#fcfcfa",
  --           selectedBackground = p.dimmed3, -- "#727072",
  --         }
  --
  --         return {
  --           Comment = { fg = c.base.dimmed3, },       -- Comments
  --           Constant = { fg = c.base.magenta },       -- (preferred) any constant
  --           String = { fg = c.base.yellow },          --   a string constant: "this is a string"
  --           Character = { fg = c.base.magenta },      -- a character constant: 'c', '\n'
  --           Number = { fg = c.base.magenta },         -- a number constant: 234, 0xff
  --           Boolean = { fg = c.base.magenta },        -- a boolean constant: TRUE, false
  --           Float = { fg = c.base.magenta },          -- a floating point constant: 2.3e10
  --           Identifier = { fg = c.base.white },       -- (preferred) any variable name
  --           Function = { fg = c.base.green },         -- function name (also: methods for classes)
  --           Statement = { fg = c.base.magenta },      -- (preferred) any statement
  --           Conditional = { fg = c.base.red },        --  if, then, else, endif, switch, etc
  --           Repeat = { fg = c.base.red },             -- for, do, while, etc
  --           Label = { fg = c.base.red },              -- case, default, etc
  --           Operator = { fg = c.base.red },           -- "sizeof", "+", "*", etc
  --           Keyword = { fg = c.base.red, },           -- any other keyword
  --           Exception = { fg = c.base.red },          -- try, catch, throw
  --           PreProc = { fg = c.base.yellow },         -- (preferred) generic Preprocessor
  --           Include = { fg = c.base.red },            -- preprocessor #include
  --           Define = { fg = c.base.red },             -- preprocessor #define
  --           Macro = { fg = c.base.red },              -- same as Define
  --           PreCondit = { fg = c.base.red },          -- preprocessor #if, #else, #endif, etc
  --           Type = { fg = c.base.white },             -- React, ReactDOM (import React from 'react';)
  --           StorageClass = { fg = c.base.red, },      -- static, register, volatile, etc
  --           Structure = { fg = c.base.cyan, },        -- struct, union, enum, etc
  --           Typedef = { fg = c.base.red },            -- A typedef
  --           Special = { fg = c.base.blue },           -- (preferred) any special symbol
  --           SpecialChar = { fg = c.base.blue },       -- special character in a constant
  --           -- Tag = {}, -- you can use CTRL-] on this
  --           Delimiter = { fg = c.base.white },        -- character that needs attention
  --           SpecialComment = { fg = c.base.dimmed3 }, -- special things inside a comment
  --           -- Debug = {}, -- debugging statements
  --           Underlined = { underline = true },        -- (preferred) text that stands out, HTML links
  --           Bold = { bold = true },
  --           -- Ignore = { }, -- (preferred) left blank, hidden  |hl-Ignore|
  --           Italic = { italic = true },
  --           Error = { fg = c.red }, -- (preferred) any erroneous construct
  --           Todo = {
  --             -- bg = c.editor.background,
  --             fg = c.base.magenta,
  --             bold = true,
  --           },                                                    -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
  --           ["@include"] = { fg = c.base.red },                   -- `import`
  --           ["@variable"] = { fg = c.base.white },
  --           ["@punctuation.delimiter"] = { fg = c.base.dimmed2 }, -- `;`
  --           ["@punctuation.bracket"] = { fg = c.base.dimmed2 },   -- `(`
  --           ["@constructor"] = { fg = c.base.red },               -- `StrictMode` in `<React.StrictMode>`
  --           ["@tag.delimiter"] = { fg = c.base.dimmed2 },         -- `<`, `>` in `<div>`
  --           ["@operator"] = { fg = c.base.red },                  -- `=`, `=>`
  --           ["@keyword"] = { fg = c.base.cyan, italic = true },   -- `const`, `export`, `default`
  --           ["@parameter"] = { fg = c.base.white },
  --           ["@string.documentation"] = { fg = c.base.dimmed3 },
  --           ["@type.builtin"] = { fg = c.base.cyan },
  --           ["@_isinstance"] = { fg = c.base.green },
  --
  --           ["@keyword.return"] = { fg = c.base.red },
  --           ["@keyword.operator"] = { fg = c.base.red },
  --           ["@method.call"] = { fg = c.base.green },
  --           ["@property"] = { fg = c.base.white },
  --           ["@function"] = { fg = c.base.green },
  --           ["@constant.builtin"] = { fg = c.base.magenta },
  --           ["@tag"] = { fg = c.base.red },
  --           ["@tag.attribute"] = { fg = c.base.cyan, italic = true },
  --           ["@attribute"] = { fg = c.base.cyan },
  --           ["@conditional"] = { fg = c.base.red },
  --           ["@repeat"] = { fg = c.base.red },
  --           ["@keyword.function"] = { fg = c.base.cyan, bold = true, italic = true },
  --           ["@number"] = { fg = c.base.magenta },
  --           ["@boolean"] = { fg = c.base.magenta },
  --           ["@type.qualifier"] = { fg = c.base.red, italic = true },
  --           ["@annotation"] = { fg = c.base.cyan, italic = true },
  --           ["@field"] = { fg = c.base.red },
  --           -- scss
  --           ["@keyword.scss"] = { fg = c.base.red },
  --           ["@function.scss"] = { fg = c.base.cyan },
  --           ["@property.scss"] = { fg = c.base.green },
  --           ["@string.scss"] = { fg = c.base.blue, italic = true },
  --           ["@number.scss"] = { fg = c.base.magenta },
  --           ["@type.scss"] = { fg = c.base.cyan },
  --           -- cpp
  --           ["@keyword.cpp"] = { fg = c.base.cyan, italic = true },
  --           ["@namespace.cpp"] = { fg = c.base.white },
  --           ["@operator.cpp"] = { fg = c.base.red },
  --           ["@type.cpp"] = { fg = c.base.blue, italic = true },
  --           ["@variable.cpp"] = { fg = c.base.white },
  --           ["@constant.cpp"] = { fg = c.base.cyan },
  --           ["@constant.macro.cpp"] = { fg = c.base.red },
  --           ["@punctuation.delimiter.cpp"] = { fg = c.sideBar.foreground },
  --           -- python
  --           ["@type.python"] = { fg = c.base.white },
  --           ["@keyword.python"] = { fg = c.base.cyan, italic = true },
  --           ["@variable.builtin.python"] = {
  --             fg = c.editorSuggestWidget.foreground,
  --             italic = true,
  --           },
  --           ["@field.python"] = { fg = c.base.white },
  --           ["@variable.python"] = { fg = c.base.white },
  --           ["@constructor.python"] = { fg = c.base.green },
  --           ["@method.python"] = { fg = c.base.green },
  --           ["@function.builtin.python"] = { fg = c.base.cyan, italic = true },
  --           ["@exception.python"] = { fg = c.base.red, italic = true },
  --           ["@constant.python"] = { fg = c.base.magenta },
  --           ["@keyword.function.python"] = { fg = c.base.cyan, italic = true },
  --           ["@operator.python"] = { fg = c.base.red },
  --           ["@varibale.builtin.python"] = { fg = c.base.blue, italic = true },
  --           ["@parameter.python"] = { fg = c.base.blue, italic = true },
  --           -- ruby
  --           ["@variable.ruby"] = { fg = c.base.white },
  --           ["@symbol.ruby"] = { fg = c.base.magenta },
  --           ["@property.ruby"] = { fg = c.base.magenta },
  --           ["@error.ruby"] = { fg = c.base.magenta },
  --           ["@constant.ruby"] = { fg = c.base.magenta },
  --           ["@label.ruby"] = { fg = c.base.magenta },
  --           ["@text.danger.ruby"] = { fg = c.base.magenta },
  --           ["@function.builtin.ruby"] = { fg = c.base.red },
  --           ["@type.ruby"] = { fg = c.base.cyan },
  --           ["@field.ruby"] = { fg = c.base.white },
  --           ["@keyword.ruby"] = { fg = c.base.red, italic = true },
  --           ["@exception.ruby"] = { fg = c.base.red, italic = true },
  --           ["@keyword.function.ruby"] = { fg = c.base.red },
  --           ["@conditional.ruby"] = { fg = c.base.red },
  --           ["@namespace.ruby"] = { fg = c.base.magenta },
  --           ["@parameter.ruby"] = { fg = c.base.blue, italic = true },
  --           -- lua
  --           ["@variable.lua"] = { fg = c.base.white },
  --           ["@function.builtin.lua"] = { fg = c.base.green },
  --           ["@field.lua"] = { fg = c.base.white },
  --           ["@keyword.lua"] = { fg = c.base.red, italic = true },
  --           ["@keyword.function.lua"] = { fg = c.base.red },
  --           ["@conditional.lua"] = { fg = c.base.red },
  --           ["@namespace.lua"] = { fg = c.base.red },
  --           ["@comment.documentation.lua"] = { fg = c.base.cyan },
  --           ["@parameter.lua"] = { fg = c.base.blue, italic = true },
  --           -- latex
  --           ["@text.environment.latex"] = { fg = c.base.green },
  --           ["@text.environment.name.latex"] = { fg = c.base.blue, italic = true },
  --           ["@punctuation.special.latex"] = { fg = c.base.red },
  --           ["@text.math.latex"] = { fg = c.base.magenta },
  --           ["@text.strong.latex"] = { bold = true },
  --           ["@text.emphasis.latex"] = { italic = true },
  --           ["@string.latex"] = { fg = c.base.cyan },
  --           ["@function.macro.latex"] = { fg = c.base.green },
  --           -- Dockerfile
  --           ["@keyword.dockerfile"] = { fg = c.base.red },
  --           ["@lsp.type.class.dockerfile"] = { fg = c.base.cyan },
  --           ["@function.call.bash"] = { fg = c.base.green },
  --           ["@parameter.bash"] = { fg = c.base.white },
  --         }
  --       end,
  --       integrations = {
  --         cmp = true,
  --         gitsigns = true,
  --         nvimtree = true,
  --         treesitter = true,
  --         notify = false,
  --         mini = false,
  --         -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
  --       },
  --     })
  --   end
  -- },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     require("tokyonight").setup({
  --       -- your configuration comes here
  --       -- or leave it empty to use the default settings
  --       style = "night",  -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
  --       light_style = "day", -- The theme is used when the background is set to light
  --       transparent = false, -- Enable this to disable setting the background color
  --       terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
  --       styles = {
  --         -- Style to be applied to different syntax groups
  --         -- Value is any valid attr-list value for `:help nvim_set_hl`
  --         comments = { italic = true },
  --         keywords = { italic = true },
  --         functions = {},
  --         variables = {},
  --         -- Background styles. Can be "dark", "transparent" or "normal"
  --         sidebars = "dark",        -- style for sidebars, see below
  --         floats = "dark",          -- style for floating windows
  --       },
  --       sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  --       day_brightness = 0.3,       -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  --       hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  --       dim_inactive = false,       -- dims inactive windows
  --       lualine_bold = false,       -- When `true`, section headers in the lualine theme will be bold
  --
  --       --- You can override specific color groups to use other groups or a hex color
  --       --- function will be called with a ColorScheme table
  --       ---@param colors ColorScheme
  --       on_colors = function(colors) end,
  --
  --       --- You can override specific highlights to use other groups or a hex color
  --       --- function will be called with a Highlights and ColorScheme table
  --       ---@param highlights Highlights
  --       ---@param colors ColorScheme
  --       on_highlights = function(highlights, colors) end,
  --     })
  --   end
  -- },
  {
    "skmtkytr/monokai-pro.nvim",
    branch = "update-treesitter-highlight-for-ruby",
    lazy = false,
    priority = 1000,
    opts = {},
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      require("monokai-pro").setup({
        transparent_background = vim.g.transparent_enabled,
        terminal_colors = false,
        devicons = true, -- highlight the icons of `nvim-web-devicons`
        styles = {
          comment = { italic = true },
          keyword = { italic = true },       -- any other keyword
          type = { italic = true },          -- (preferred) int, long, char, etc
          storageclass = { italic = true },  -- static, register, volatile, etc
          structure = { italic = true },     -- struct, union, enum, etc
          parameter = { italic = true },     -- parameter pass in function
          annotation = { italic = true },
          tag_attribute = { italic = true }, -- attribute of tag in reactjs
        },
        filter = "spectrum",                 -- classic | octagon | pro | machine | ristretto | spectrum
        -- Enable this will disable filter option
        day_night = {
          enable = false,            -- turn off by default
          day_filter = "pro",        -- classic | octagon | pro | machine | ristretto | spectrum
          night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
        },
        inc_search = "underline",    -- underline | background
        background_clear = {
          "float_win",
          "toggleterm",
          "telescope",
          "which-key",
          -- "renamer",
          "notify",
          -- "nvim-tree",
          "neo-tree",
          -- "bufferline",
          -- better used if background of `neo-tree` or `nvim-tree` is cleared
        }, -- "float_win","toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
        plugins = {
          bufferline = {
            underline_selected = false,
            underline_visible = false,
          },
          indent_blankline = {
            context_highlight = "default", -- default | pro
            context_start_underline = false,
          },
        },
        ---@param c Colorscheme
        override = function(c) end,
      })
    end
  },


  {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
            { desc = '󰊳 Profile', group = '@property', action = 'Lazy profile', key = 'p' },
            {
              icon = ' ',
              icon_hl = '@variable',
              desc = 'Files',
              group = 'Label',
              action = 'FzfLua files',
              key = 'f',
            },
            {
              desc = ' MRU',
              group = 'DiagnosticHint',
              action = 'FzfLua oldfiles',
              key = 'a',
            },
            {
              desc = ' dotfiles',
              group = 'Number',
              action = 'FzfLua files cwd=~/dotfiles',
              key = 'd',
            },
          },
        },
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },

  -- Tab UIs
  {
    'akinsho/bufferline.nvim',
    tag = "v4.2.0",
    event = { "BufRead", "BufNewFile" },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          mode = "tabs", -- set to "tabs" to only show tabpages instead
          separator_style = 'slant',
          always_show_bufferline = true,
          style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
          max_name_length = 18,
          tab_size = 18,
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          color_icons = true -- whether or not to add the filetype icon highlights
        }
      }
    end
  },

  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutlineOpen",
    config = function()
      require("symbols-outline").setup()
    end
  },

  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      bottom = {
        -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
        -- {
        --   ft = "toggleterm",
        --   size = { height = 0.25 },
        --   -- exclude floating windows
        --   filter = function(buf, win)
        --     return vim.api.nvim_win_get_config(win).relative == ""
        --   end,
        -- },
        {
          ft = "lazyterm",
          title = "LazyTerm",
          size = { height = 0.25 },
          filter = function(buf)
            return not vim.b[buf].lazyterm_cmd
          end,
        },
        "Trouble",
        { ft = "qf",            title = "QuickFix" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
        { ft = "spectre_panel", size = { height = 0.4 } },
      },
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.4 },
        },
        {
          title = "Neo-Tree Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
        {
          title = "Neo-Tree Buffers",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
          pinned = true,
          open = "Neotree position=top buffers",
        },
        {
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutlineOpen",
          -- open = "Lspsaga outline",
        },
        -- any other neo-tree windows
        "neo-tree",
      },
    },
  },

  -- Colorizer plugins
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    event = { "BufRead", "BufNewFile" },
    -- lazy = false,
    opts = {
      input = {
        win_options = { winblend = 0 },
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- noicer ui
  -- lich builtin cmdline, notify
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- cmd = { "Noice", "NoiceToggle" },
    dependencies = {
      { "MunifTanjim/nui.nvim" },
      {
        "rcarriga/nvim-notify",
        module = { "notify" },
        config = function()
          require("notify").setup {
            -- nvim-notify の設定
          }
        end
      },
    },
    opts = {
      cmdline = {
        view = "cmdline_popup",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
      },
      -- lsp = {
      --   progress = { enabled = true },
      --   hover = { enabled = false },
      --   signature = { enabled = false },
      --   -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      --   override = {
      --     ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      --     ["vim.lsp.util.stylize_markdown"] = true,
      --     ["cmp.entry.get_documentation"] = true,
      --   },
      -- },
      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
        },
      },
    },
  },

  -- Test interacting
  {
    "nvim-neotest/neotest",
    cmd = 'Neotest',
    keys = {
      { "<leader>ts", ":Neotest summary<CR>", silent = true, desc = "open [T]est [S]ummary" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec")({
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
                  "rspec"
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
              local prefix = require('neotest-rspec').root(path)
              return string.sub(path, string.len(prefix) + 2, -1)
            end,

            results_path = "tmp/rspec.output"
          })
        },
      })
    end
  },
  -- vim session manager
  -- {
  --   'rmagatti/auto-session',
  --   config = function()
  --     require("auto-session").setup {
  --       log_level = "error",
  --       auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
  --     }
  --   end
  -- },

  -- Additional lua configuration, makes nvim stuff amazing!
  {
    'folke/neodev.nvim',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require('neodev').setup()
    end
  },

  -- Define your keymaps, commands, and autocommands as simple Lua tables, building a legend at the same time (like VS Code's Command Palette).
  -- {
  --   'mrjones2014/legendary.nvim',
  --   -- since legendary.nvim handles all your keymaps/commands,
  --   -- its recommended to load legendary.nvim before other plugins
  --   priority = 10000,
  --   lazy = false,
  --   -- sqlite is only needed if you want to use frecency sorting
  --   -- dependencies = { 'kkharji/sqlite.lua' }
  -- },

  -- improve neovim builtin terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
      { "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", desc = "open [L]azy[g]it" },
    },
    opts = {
      autochdir = true,
    },
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
      function _lazygit_toggle()
        lazygit:toggle()
      end
    end
  },

}, {
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      -- reset = true,        -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to includes in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        -- "tarPlugin",
        -- "tohtml",
        -- "tutor",
        "zipPlugin",
      },
    },
  }
})

-- local function builtin(name)
--   return function(opt)
--     return function()
--       return require("telescope.builtin")[name](opt or {})
--     end
--   end
-- end
--
-- local function extensions(name, prop)
--   return function(opt)
--     return function()
--       local telescope = require "telescope"
--       telescope.load_extension(name)
--       return telescope.extensions[name][prop](opt or {})
--     end
--   end
-- end

-- vim.keymap.set("n", "<C-p>", builtin "find_files" { hidden = true, ["layout_config.preview_width"] = 0.8 })
-- vim.keymap.set("n", "<Space>f", builtin "live_grep" {})
-- vim.keymap.set("n", "<Leader>fG", builtin "grep_string" {})
-- vim.keymap.set("n", ";cb",
--   "<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD'})<CR>",
--   { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-O>", builtin "lsp_document_symbols" {})
