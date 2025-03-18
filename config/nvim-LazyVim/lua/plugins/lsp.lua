-- lsp plugins

return {
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    keys = {
      { "gd", "<cmd>Glance definitions<CR>" },
      { "gr", "<cmd>Glance references<CR>" },
      { "gy", "<cmd>Glance type_definitions<CR>" },
      { "gm", "<cmd>Glance implementations<CR>" },
    },
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = { "LspAttach" },
    priority = 1000,
    opts = {
      -- Style preset for diagnostic messages
      -- Available options:
      -- "modern", "classic", "minimal", "powerline",
      -- "ghost", "simple", "nonerdfont", "amongus"
      preset = "powerline",
      transparent_bg = false, -- Set the background of the diagnostic to transparent
      options = {
        multilines = {
          -- Enable multiline diagnostic messages
          enabled = true,

          -- Always show messages on all lines for multiline diagnostics
          always_show = true,
        },
      },
    },
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)
      vim.diagnostic.config({ virtual_text = false })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { -- optional cmp completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
  { -- optional blink completion source for require statements and module annotations
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "giuxtaposition/blink-cmp-copilot" },
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
  -- {
  --   "glepnir/lspsaga.nvim",
  --   event = { "LspAttach" },
  --   keys = {
  --     { "K", "<cmd>Lspsaga hover_doc<CR>" },
  --     { "gr", "<cmd>Lspsaga finder<CR>" },
  --     { "gd", "<cmd>Lspsaga peek_definition<CR>" },
  --     { "gdv", ":vsplit | lua vim.lsp.buf.definition()<CR>" },
  --     { "ga", "<cmd>Lspsaga code_action<CR>" },
  --     { "gn", "<cmd>Lspsaga rename<CR>" },
  --     { "<leader>uo", "<cmd>Lspsaga outline<CR>" },
  --     { "ge", "<cmd>Lspsaga show_line_diagnostics<CR>" },
  --     { "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>" },
  --     { "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>" },
  --   },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     -- "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("lspsaga").setup()
  --   end,
  -- }, -- LSP UIs
}
