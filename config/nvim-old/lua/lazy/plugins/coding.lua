return {

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

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!:).
    build = "make install_jsregexp",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- cmp plugins
  {
    "hrsh7th/nvim-cmp",
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
        event = { "InsertEnter" },
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
  },

  -- Github copilot
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = { "InsertEnter" },
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- motion
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  -- Formatter
  { "MunifTanjim/prettier.nvim" },

  -- comment outer
  { "tyru/caw.vim" },

}
