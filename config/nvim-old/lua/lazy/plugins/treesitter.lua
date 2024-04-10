return {

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
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
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "xml",
      "php",
      "markdown",
      "glimmer",
      "handlebars",
      "hbs",
    },
    opts = {
      enable = true,
      filetypes = {
        "html",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "svelte",
        "vue",
        "tsx",
        "jsx",
        "rescript",
        "xml",
        "php",
        "markdown",
        "glimmer",
        "handlebars",
        "hbs",
      },
    },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    ft = {
      "ruby",
    }
  },
  { "nvim-treesitter/playground",     cmd = "TSPlaygroundToggle" },
}
