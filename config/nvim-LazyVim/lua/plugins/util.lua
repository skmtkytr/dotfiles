-- util settings

return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "oil" },
      disabled_keys = {
        -- ["<Up>"] = {},
        -- ["<Space>"] = { "n", "x" },
      },
    },
    config = function(_, opts)
      require("hardtime").setup(opts)
    end,
  },
  { "pteroctopus/faster.nvim" },
  { "dstein64/vim-startuptime" },
  {
    "gamoutatsumi/dps-ghosttext.vim",
    cmd = { "GhostStart" },
    dependencies = {
      { "vim-denops/denops.vim" },
    },
  },
  {
    "lambdalisue/vim-manpager",
    cmd = "ASMANPAGER",
  },

  { "Omochice/yank-remote-url.vim", lazy = true },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- take screenshot in vim
  {
    "segeljakt/vim-silicon",
    cmd = "Silicon",
  },

  {
    "folke/which-key.nvim",
    optional = true,
    keys = {
      { "<F3>", "<cmd>OtherClear<CR><cmd>:Other<CR>" },
      { "<leader>os", "<cmd>OtherClear<CR><cmd>:OtherSplit<CR>" },
      { "<leader>ov", "<cmd>OtherClear<CR><cmd>:OtherVSplit<CR>" },
    },
    opts = function(_, opts)
      if LazyVim.has("noice.nvim") then
        opts.spec = { "<leader>o", name = "+Other" }
      end
    end,
  },

  -- other.vim
  {
    "rgroli/other.nvim",
    cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
    config = function()
      local rails_controller_patterns = {
        { target = "/spec/controllers/%1_spec.rb", context = "spec" },
        { target = "/spec/requests/%1_spec.rb", context = "spec" },
        { target = "/spec/factories/%1.rb", context = "factories", transformer = "singularize" },
        { target = "/app/models/%1.rb", context = "models", transformer = "singularize" },
        { target = "/app/controllers/%1.rb", context = "controllers", transformer = "singularize" },
        { target = "/app/views/%1/**/*.html.*", context = "view" },
      }
      local sveltekit_target = {
        { target = "/%1/%+%2.svelte", context = "view" },
        { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "remove_server" },
        { target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transform = "add_server" },
      }
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          -- "livewire",
          -- "angular",
          -- "laravel",
          "rails",
          "golang",
          -- custom mapping
          {
            pattern = "/app/models/(.*).rb",
            target = {
              { target = "/spec/models/%1_spec.rb", context = "spec" },
              { target = "/spec/factories/%1.rb", context = "factories", transformer = "pluralize" },
              { target = "/app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
              { target = "/app/views/%1/**/*.html.*", context = "view", transformer = "pluralize" },
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
              { target = "/app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "/spec/models/%1_spec.rb", context = "spec", transformer = "singularize" },
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
            pattern = "spec/requests/(.*)_spec.rb",
            target = rails_controller_patterns,
          },
          {
            pattern = "spec/controllers/(.*)_spec.rb",
            target = rails_controller_patterns,
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
              { target = "/spec/factories/%1.rb", context = "factories", transformer = "singularize" },
              { target = "/app/models/%1.rb", context = "models", transformer = "singularize" },
              { target = "/app/controllers/**/%1_controller.rb", context = "controller", transformer = "pluralize" },
            },
          },
          {
            pattern = "/app/contexts/(.*).rb$",
            target = {
              { target = "/app/contexts/%1.rbs", context = "sig" },
              { target = "/spec/contexts/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "/app/contexts/(.*).rbs$",
            target = {
              { target = "/app/contexts/%1.rb", context = "app" },
              { target = "/spec/contexts/%1_spec.rb", context = "spec" },
            },
          },
          {
            pattern = "/spec/contexts/(.*)_spec.rb$",
            target = {
              { target = "/app/contexts/%1.rb", context = "app" },
            },
          },
          {
            pattern = "/lib/(.*)/(.*).rb",
            target = {
              { target = "/spec/%1_spec.rb", context = "spec" },
              { target = "/sig/%1.rbs", context = "sig" },
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
              { target = "/app/%1.rb", context = "app" },
              { target = "/lib/%1.rb", context = "lib" },
              { target = "/sig/%1.rbs", context = "sig" },
            },
          },
          -- sveltekit
          {
            pattern = "/(.*)/%+(.*).server.ts$",
            target = sveltekit_target,
          },
          {
            pattern = "/(.*)/%+(.*).server.js$",
            target = sveltekit_target,
          },
          {
            pattern = "/(.*)/%+(.*).ts$",
            target = sveltekit_target,
          },
          {
            pattern = "/(.*)/%+(.*).js$",
            target = sveltekit_target,
          },
          {
            pattern = "/(.*)/%+(.*).svelte$",
            target = sveltekit_target,
          },
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function(inputString)
            return inputString:lower()
          end,
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
          minHeight = 2,
        },
      })
    end,
  },
}
