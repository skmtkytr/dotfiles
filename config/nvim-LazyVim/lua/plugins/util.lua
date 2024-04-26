-- util settings

return {
  {
    "sigmasd/deno-nvim",
    lazy = true,
  },
  { "vim-denops/denops.vim", lazy = true },

  { "Omochice/yank-remote-url.vim", lazy = true },

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
        opts.defaults["<leader>o"] = { name = "+Other" }
      end
    end,
  },

  -- other.vim
  {
    "rgroli/other.nvim",
    cmd = { "Other", "OtherClear" },
    config = function()
      rails_controller_patterns = {
        { target = "/spec/controllers/%1_spec.rb", context = "spec" },
        { target = "/spec/requests/%1_spec.rb", context = "spec" },
        { target = "/spec/factories/%1.rb", context = "factories", transformer = "singularize" },
        { target = "/app/models/%1.rb", context = "models", transformer = "singularize" },
        { target = "/app/controllers/%1.rb", context = "controllers", transformer = "singularize" },
        { target = "/app/views/%1/**/*.html.*", context = "view" },
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
