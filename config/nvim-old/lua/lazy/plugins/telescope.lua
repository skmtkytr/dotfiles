local Util = require("util")

return {

  -- Telescope
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    cmd = 'Telescope',
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    cmd = 'Telescope',
    keys = {
      { ';cb', ":Telescope frecency workspace=CWD<CR>" },
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
    dependencies = { "kkharji/sqlite.lua" }
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { "nvim-telescope/telescope-file-browser.nvim", },
      { "nvim-telescope/telescope-frecency.nvim", },
    },
    cmd = 'Telescope',
    keys = {
      { '<C-p>',      ':Telescope find_files find_command=rg,--files,--hidden,--glob,!*.git <CR>' },
      { '<Space>f',   ':Telescope live_grep<CR>' },
      { '<Leader>fG', ':Telescope grep_string<CR>' },
      { '<C-O>',      ':Telescope lsp_document_symbols<CR>' }
    },
    config = function()
      require('telescope').setup {
        defaults = {
          prompt_prefix          = "   ",
          selection_caret        = "  ",
          entry_prefix           = "   ",
          borderchars            = {
            prompt = Util.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            results = Util.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            preview = Util.generate_borderchars("thick", nil, { top = "█", top_left = "█", top_right = "█" }),
          },
          dynamic_preview_title  = true,
          hl_result_eol          = true,
          sorting_strategy       = "ascending",
          file_ignore_patterns   = {
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
            "%.epub",
            "%.flac",
            "%.tar.gz",
          },
          results_title          = "",
          layout_config          = {
            horizontal     = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical       = {
              mirror = false,
            },
            width          = 0.87,
            height         = 0.80,
            preview_cutoff = 120,
          },
          pickers                = {
            find_files = {
              theme = "dropdown",
              layout_config = {
                width = 0.9,
              },
              ignore_patterns = { "node_modules", "vendor", "tmp" },
            },
          },
          extensions             = {
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
          file_sorter            = require('telescope.sorters').get_fzy_sorter,
          color_devicons         = true,

          file_previewer         = require('telescope.previewers').vim_buffer_cat.new,
          grep_previewer         = require('telescope.previewers').vim_buffer_vimgrep.new,
          qflist_previewer       = require('telescope.previewers').vim_buffer_qflist.new,

          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker
        },
      }
    end,
  },

}
