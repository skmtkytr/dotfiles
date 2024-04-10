return {
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
  {
    "skmtkytr/monokai-pro.nvim",
    branch = "update-treesitter-highlight-for-ruby",
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
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
          -- "float_win",
          -- "toggleterm",
          "telescope",
          -- "which-key",
          -- "renamer",
          -- "notify",
          "nvim-tree",
          -- "neo-tree",
          -- "bufferline",
          -- better used if background of `neo-tree` or `nvim-tree` is cleared
        }, -- "float_win","toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = false,
            underline_fill = true,
            bold = false,
          },
          indent_blankline = {
            context_highlight = "pro", -- default | pro
            context_start_underline = true,
          },
        },
        ---@param c Colorscheme
        override = function(c) end,
      })
      monokai.load()
    end,
  },
}
