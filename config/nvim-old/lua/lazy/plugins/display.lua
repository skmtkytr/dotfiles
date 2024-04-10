return {

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
  },

  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    config = function() require("nvim-autopairs").setup {} end
  }, -- Autopairs,integrates with both cmp and treesitter

  -- {
  --   "glepnir/dashboard-nvim",
  --   event = "VimEnter",
  --   dependencies = { { "nvim-tree/nvim-web-devicons" } },
  --   keys = { { "<leader>0", "<cmd>Dashboard<CR>", desc = "Dashboard" } },
  --   config = function()
  --     require("config.dashboard")
  --   end,
  -- },
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
  { "mattn/vim-lsp-icons", lazy = true, },                 -- File icons

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


  -- lich builtin cmdline, notify
  --  {
  --   "folke/noice.nvim",
  --   -- event = { "BufRead", "BufNewFile", "InsertEnter", "CmdlineEnter" },
  --   -- module = { "noice" },
  --   dependencies = {
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
    event = { "BufRead", "BufNewFile" },
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
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    keys = {
      { '<M-w>',  ':NvimTreeToggle<CR>' },
      { '<C-j>w', ':NvimTreeFindFile<CR>' }
    },
    config = function()
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
    "norcalli/nvim-colorizer.lua",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end
  },

  -- git commit outline
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs                        = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn                   = true,    -- Toggle with `:Gitsigns toggle_signs`
      numhl                        = true,    -- Toggle with `:Gitsigns toggle_numhl`
      linehl                       = false,   -- Toggle with `:Gitsigns toggle_linehl`
      word_diff                    = false,   -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir                 = {
        follow_files = true
      },
      attach_to_untracked          = true,
      current_line_blame           = false,   -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts      = {
        virt_text = true,
        virt_text_pos = 'eol',   -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      sign_priority                = 6,
      update_debounce              = 100,
      status_formatter             = nil,     -- Use default
      max_file_length              = 40000,   -- Disable if file is longer than this (in lines)
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
  },
  { "tpope/vim-fugitive", cmd = "Git" },

}
