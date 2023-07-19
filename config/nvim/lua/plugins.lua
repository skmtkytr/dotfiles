local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    non_interactive = true,
    open_fn = function()
      return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  use "dstein64/vim-startuptime"
  -- My plugins here

  use({ "wbthomason/packer.nvim" })
  use({ "nvim-lua/plenary.nvim" }) -- Common utilities
  use({ "tpope/vim-surround" })

  -- Colorschemes
  use "sainnhe/sonokai"
  use({
    "EdenEast/nightfox.nvim",
    config = function()
      -- Default options
      require('nightfox').setup({
        options = {
          -- Compiled file's destination location
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",       -- Compiled file suffix
          transparent = vim.g.transparent_enabled, -- Disable setting background
          terminal_colors = true,                  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
          dim_inactive = false,                    -- Non focused panes set to alternative background
          module_default = true,                   -- Default enable value for modules
          colorblind = {
            enable = false,                        -- Enable colorblind support
            simulate_only = false,                 -- Only show simulated colorblind colors and not diff shifted
            severity = {
              protan = 0,                          -- Severity [0,1] for protan (red)
              deutan = 0,                          -- Severity [0,1] for deutan (green)
              tritan = 0,                          -- Severity [0,1] for tritan (blue)
            },
          },
          styles = {             -- Style to be applied to different syntax groups
            comments = "italic", -- Value is any valid attr-list value `:help attr-list`
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = { -- Inverse highlight for different types
            match_paren = false,
            visual = false,
            search = false,
          },
          modules = { -- List of various plugins and additional options
            -- ...
          },
        },
        palettes = {
          name = "carbonfox",
        },
        specs = {},
        groups = {},
      })
      -- require("nightfox.config").set_fox("duskfox")
      -- require("nightfox").load()
    end
  })
  -- use "phanviet/vim-monokai-pro"

  use {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
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
        inc_search = "background",   -- underline | background
        background_clear = {
          -- "float_win",
          -- "toggleterm",
          "telescope",
          -- "which-key",
          -- "renamer",
          -- "notify",
          "nvim-tree",
          -- "neo-tree",
          "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
        },              -- "float_win","toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
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
  }

  use({
    "folke/which-key.nvim",
    config = function()
      local wk = require "which-key"
      wk.register({
        ["<leader>o"] = {
          name = "+Other",
        },
      })
      vim.keymap.set("n", "<F3>", "<cmd>OtherClear<CR><cmd>:Other<CR>")
      vim.keymap.set("n", "<leader>os", "<cmd>OtherClear<CR><cmd>:OtherSplit<CR>")
      vim.keymap.set("n", "<leader>ov", "<cmd>OtherClear<CR><cmd>:OtherVSplit<CR>")
    end
  })

  -- Statusline
  use {
    "nvim-lualine/lualine.nvim",
    event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
    requires = {
      { "nvim-tree/nvim-web-devicons" },
    },
    setup = function()
      vim.opt.laststatus = 0
      vim.opt.showtabline = 0
    end,
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
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
  }

  use({
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  }) -- Autopairs,integrates with both cmp and treesitter
  use({
    "nvim-tree/nvim-web-devicons",
    config = function()
      require 'nvim-web-devicons'.setup {
        -- your personnal icons can go here (to override)
        -- you can specify color or cterm_color instead of specifying both of them
        -- DevIcon will be appended to `name`
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
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
  })                             -- File icons
  use({ "mattn/vim-lsp-icons" }) -- File icons

  -- Github copilot
  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  }
  use {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter" },
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end
  }

  -- cmp plugins
  use({
    "hrsh7th/nvim-cmp",
    module = { "cmp" },
    requires = {
      { "hrsh7th/cmp-buffer",                  event = { "InsertEnter" } },
      { "hrsh7th/cmp-path",                    event = { "InsertEnter" } },
      { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
      { "saadparwaiz1/cmp_luasnip",            event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lsp",                event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lua",                event = { "InsertEnter" } },
      { "hrsh7th/cmp-cmdline",                 event = { "InsertEnter" } },
      { "hrsh7th/cmp-nvim-lsp-signature-help", event = { "InsertEnter" } },
      {
        "zbirenbaum/copilot-cmp",
        event = { "InsertEnter" },
        after = { "copilot.lua" },
        config = function()
          require("copilot_cmp").setup()
        end
      },
    },
    config = function()
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
      local cmp = require "cmp"
      local lspkind = require('lspkind')
      cmp.setup({
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
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
  })                                  -- The completion plugin
  use({ "hrsh7th/cmp-buffer" })       -- buffer completions
  use({ "hrsh7th/cmp-path" })         -- path completions
  use({ "hrsh7th/cmp-cmdline" })      -- cmdline completions
  use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions
  use({ "hrsh7th/cmp-nvim-lsp" })
  use({ "hrsh7th/cmp-nvim-lua" })
  use({ "hrsh7th/cmp-nvim-lsp-signature-help" })
  use({ "onsails/lspkind-nvim" })
  use({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup {}
    end
  })

  -- snippets
  use({
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    tag = "v<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    run = "make install_jsregexp"
  })

  -- LSP
  use({
    "neovim/nvim-lspconfig",
  })                                         -- enable LSP
  use({ "williamboman/nvim-lsp-installer" }) -- simple to use language server installer
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
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
          null_ls.builtins.diagnostics.luacheck.with({
            extra_args = { "--globals", "vim", "--globals", "awesome" },
          }),
          null_ls.builtins.diagnostics.yamllint,
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
  })

  use({
    "glepnir/lspsaga.nvim",
    -- event = { "LspAttach" },
    after = 'nvim-lspconfig',
    config = function()
      require('lspsaga').setup({})
    end
  }) -- LSP UIs
  --  use({ "prabirshrestha/vim-lsp" }) -- LSP
  --  use({ 'mattn/vim-lsp-settings' }) -- LSP suggest installer
  use({
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
    end
  })
  use({
    'williamboman/mason-lspconfig.nvim',
    config = function()
      require('mason-lspconfig').setup_handlers({ function(server)
        local opt = {
          -- -- Function executed when the LSP server startup
          on_attach = function(client, bufnr)
            if client.server_capabilities.documentFormattingProvider then
              vim.cmd(
                [[
             augroup LspFormatting
             autocmd! * <buffer>
             autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
             augroup END
             ]]
              )
            end
            -- vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil,1000)'
          end,
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
                -- Get the language server to recognize the `vim` global
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
  })

  -- LSP diagnostics UI plugins
  -- use({
  --   "folke/trouble.nvim",
  --   requires = "nvim-tree/nvim-web-devicons",
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
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
      })
    end,
  })


  -- other.vim
  local rails_controller_patterns = {
    { target = "/spec/controllers/%1_spec.rb", context = "spec" },
    { target = "/spec/requests/%1_spec.rb",    context = "spec" },
    { target = "/spec/factories/%1.rb",        context = "factories", transformer = "singularize" },
    { target = "/app/models/%1.rb",            context = "models",    transformer = "singularize" },
    { target = "/app/views/%1/**/*.html.*",    context = "view" },
  }
  use {
    'rgroli/other.nvim',
    config = function()
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          -- "rails",
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
            pattern = "/app/contexts/(.*).rb",
            target = {
              { target = "/app/contexts/%1.rbs",      context = "sig" },
              { target = "/spec/contexts/%1_spec.rb", context = "spec" },
            },
          },
          {
          },
          {
            pattern = "/lib/(.*).rb",
            target = {
              { target = "/spec/%1_spec.rb", context = "spec" },
              { target = "/sig/%1.rbs",      context = "sig" },
            },
          },
          {
            pattern = "/sig/(.*).rbs",
            target = {
              { target = "/lib/%1.rb", context = "lib" },
              { target = "/%1.rb" },
            },
          },
          {
            pattern = "/spec/(.*)_spec.rb",
            target = {
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
  }

  -- motion
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Formatter
  use({ "MunifTanjim/prettier.nvim" })

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    -- module = { "telescope" },
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-file-browser.nvim", opt = true },
    },
    wants = {
      "telescope-file-browser.nvim",
      "telescope-fzf-native.nvim",
    },
    setup = function()
      local function builtin(name)
        return function(opt)
          return function()
            return require("telescope.builtin")[name](opt or {})
          end
        end
      end

      local function extensions(name, prop)
        return function(opt)
          return function()
            local telescope = require "telescope"
            telescope.load_extension(name)
            return telescope.extensions[name][prop](opt or {})
          end
        end
      end

      vim.keymap.set("n", "<C-p>", builtin "find_files" { hidden = true, ["layout_config.preview_width"] = 0.8 })
      vim.keymap.set("n", "<Space>f", builtin "live_grep" {})
      vim.keymap.set("n", "<Leader>fG", builtin "grep_string" {})
      vim.keymap.set("n", ";cb", "<cmd>lua require('telescope').extensions.frecency.frecency({ workspace = 'CWD'})<CR>",
        { noremap = true, silent = true })
      vim.keymap.set("n", "<C-O>", builtin "lsp_document_symbols" {})
    end,
    config = function()
      require('telescope').setup {
        defaults = {
          leyout_config = {
            vertical               = {
              width = 0.9,
              height = 0.95,
              preview_height = 0.5,
            },
            file_sorter            = require('telescope.sorters').get_fzy_sorter,
            prompt_prefix          = ' >',
            color_devicons         = true,

            file_previewer         = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer         = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer       = require('telescope.previewers').vim_buffer_qflist.new,

            -- Developer configurations: Not meant for general override
            buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker
          }
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            layout_config = {
              width = 0.9,
            },
          },
          oldfiles = {
            theme = "dropdown",
            leuout_config = {
              width = 0.9,
            }
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = { "*.git/*", "*/tmp/*" },
            disable_devicons = false,
          }
        },
      }
      -- require('telescope').load_extension('fzy_native')
    end
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  })
  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require "telescope".load_extension("frecency")
    end,
    requires = { "kkharji/sqlite.lua" }
  }



  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    requires = { "RRethy/nvim-treesitter-endwise" },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- A list of parser names, or "all" (the five listed parsers should always be installed)
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "cpp",
          "css",
          "diff",
          "dockerfile",
          "haskell",
          "html",
          "java",
          "javascript",
          "json",
          "git_config",
          "gitcommit",
          "go",
          "graphql",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "perl",
          "php",
          "proto",
          "regex",
          "rst",
          "ruby",
          "rust",
          "scala",
          "sql",
          "tsx",
          "toml",
          "typescript",
          "vim",
          "yaml",
        },               -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        highlight = {
          enable = true, -- false will disable the whole extension
        },
        incremental_selection = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { "ruby" },
        },
        matchup = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 2000,
        },
        endwise = {
          enable = true,
        }, -- Install parsers synchronously (only applied to `ensure_installed`)
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
    { run = ":TSUpdate" }
  })
  use({ "windwp/nvim-ts-autotag" })
  use { "RRethy/nvim-treesitter-endwise" }

  -- comment outer
  use {
    'tyru/caw.vim'
  }

  -- git commit outline
  use {
    "lewis6991/gitsigns.nvim",
    event = { "FocusLost", "CursorHold", "CursorHoldI" },
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
        linehl                       = true,  -- Toggle with `:Gitsigns toggle_linehl`
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
  }
  use { "tpope/vim-fugitive" }

  use {
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
  }

  -- Tab UIs
  use {
    'akinsho/bufferline.nvim',
    tag = "v4.2.0",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require('bufferline')
      bufferline.setup {
        options = {
          mode = "tabs", -- set to "tabs" to only show tabpages instead
          separator_style = 'slant',
          always_show_bufferline = false,
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
  }
  -- use {
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
  --   requires = { { 'hoob3rt/lualine.nvim', opt = true }, { 'kyazdani42/nvim-web-devicons', opt = true } }
  -- }


  -- lich builtin cmdline, notify
  -- use {
  --   "folke/noice.nvim",
  --   -- event = { "BufRead", "BufNewFile", "InsertEnter", "CmdlineEnter" },
  --   -- module = { "noice" },
  --   requires = {
  --     { "MunifTanjim/nui.nvim" },
  --     {
  --       "rcarriga/nvim-notify",
  --       module = { "notify" },
  --       config = function()
  --         require("notify").setup {
  --           -- nvim-notify の設定
  --         }
  --       end
  --     },
  --   },
  --   wants = { "nvim-treesitter" },
  --   setup = function()
  --     if not _G.__vim_notify_overwritten then
  --       vim.notify = function(...)
  --         local arg = { ... }
  --         require "notify"
  --         require "noice"
  --         vim.schedule(function()
  --           vim.notify(unpack(args))
  --         end)
  --       end
  --       _G.__vim_notify_overwritten = true
  --     end
  --   end,
  --   config = function()
  --     require("noice").setup {
  --       -- noice.nvim の設定
  --       lsp = {
  --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --           ["vim.lsp.util.stylize_markdown"] = true,
  --           ["cmp.entry.get_documentation"] = true,
  --         },
  --       },
  --       -- you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = false, -- use a classic bottom cmdline for search
  --       },
  --
  --     }
  --   end
  -- }

  -- Intent showable
  -- use {
  --   "echasnovski/mini.indentscope",
  --   branch = 'stable',
  --   config = function()
  --     require('mini.indentscope').setup()
  --   end
  -- }
  -- use {
  --   "preservim/vim-indent-guides",
  --   config = function()
  --     vim.g.indent_guides_enable_on_vim_startup = 1
  --     vim.g.indent_guides_start_level = 2
  --     vim.g.indent_guides_guide_size = 1
  --     vim.g.indent_guides_exclude_filetypes = { 'help', 'nerdtree', 'tagbar', 'unite' }
  --   end
  -- }
  use {
    "lukas-reineke/indent-blankline.nvim",
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
  }

  -- Transparent opacity
  use {
    'xiyaowong/transparent.nvim',
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        extra_groups = {},   -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end
  }

  -- File browser
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      -- disable netrw at the very start of your init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- set termguicolors to enable highlight groups
      vim.opt.termguicolors = true

      -- empty setup using defaults
      require("nvim-tree").setup()

      -- OR setup with some options
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
      })
    end
  }

  -- Ruby plugins
  use { 'vim-ruby/vim-ruby' }
  -- use { 'tpope/vim-rails' }

  -- filetype plugins
  use { 'jlcrochet/vim-rbs', ft = "rbs" }
  -- use { "keith/rspec.vim", ft = "rb" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
