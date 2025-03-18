-- ui settings

return {
  {
    "vim-skk/skkeleton",
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  -- quickfix window better
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    dependencies = {
      "junegunn/fzf",
      run = ":call fzf#install()",
    },
  },
  {
    "mvllow/modes.nvim",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("modes").setup({
        colors = {
          copy = "#f5c359",
          delete = "#c75c6a",
          insert = "#78ccc5",
          visual = "#9745be",
        },

        -- Set opacity for cursorline and number background
        line_opacity = 0.15,

        -- Enable cursor highlights
        set_cursor = true,

        -- Enable cursorline initially, and disable cursorline for inactive windows
        -- or ignored filetypes
        set_cursorline = true,

        -- Enable line number highlights to match cursorline
        set_number = true,

        -- Disable modes highlights in specified filetypes
        -- Please PR commonly ignored filetypes
        ignore_filetypes = { "NvimTree", "TelescopePrompt", "neotest-attach" },
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    event = { "BufRead", "BufNewFile" },
    config = function()
      require("hlslens").setup({
        build_position_cb = function(plist, _, _, _)
          local ok, scrollbar = pcall(require, "scrollbar.handlers.search")
          if ok then
            scrollbar.handler.show(plist.start_pos)
          end
        end,
      })

      vim.cmd([[
        augroup scrollbar_search_hide
            autocmd!
            autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
        augroup END
    ]])
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    config = function()
      require("scrollbar").setup()
    end,
  },
  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>gg", "<cmd>lua Snacks.lazygit()<CR>" },
      { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
      { "<c-/>",      function() Snacks.terminal({"tmux", "new-session", "-A", "-s", "main" }, { cwd = LazyVim.root(), interactive = true, win = { style = "terminal" } }) end, desc = "Terminal" },
      -- { "<leader>fp", function() Snacks.picker.projects({ dev = { "~/.ghq/github.com/" }}) end, desc = "Projects"},
    },
    opts = function(_, opts)
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")

      opts.scroll = { enabled = true }
      opts.input = {
        enabled = true,
        expand = true,
      }
      opts.indent = {
        enabled = false,
        char = " ",
        only_scope = true,
        only_current = true,
      }
      Snacks.config.style("terminal", {
        width = 0.9,
        height = 0.9,
        border = "rounded",
        title = " Terminal ",
        title_pos = "center",
        ft = "terminal",
      })
    end,
    --   {
    --   lazygit = {},
    --   indent = { enabled = true },
    --   input = { enabled = true },
    --   notifier = { enabled = true },
    --   scope = { enabled = true },
    --   scroll = { enabled = false },
    --   statuscolumn = { enabled = false }, -- we set this in options.lua
    --   toggle = { map = LazyVim.safe_keymap_set },
    --   words = { enabled = true },
    --   profiler = { enabled = true },
    -- },
  },

  -- edgy settings
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      -- local edgy_idx = LazyVim.plugin.extra_idx("ui.edgy")
      -- local symbols_idx = LazyVim.plugin.extra_idx("editor.outline")
      --
      -- if edgy_idx and edgy_idx > symbols_idx then
      --   LazyVim.warn(
      --     "The `edgy.nvim` extra must be **imported** before the `outline.nvim` extra to work properly.",
      --     { title = "LazyVim" }
      --   )
      -- end

      opts.left = opts.left or {}
      opts.right = opts.right or {}
      opts.top = opts.top or {}
      opts.bottom = opts.bottom or {}
      for i = #opts.bottom, 1, -1 do
        if opts.bottom[i].ft == "snacks_terminal" then
          table.remove(opts.bottom, i)
        end
      end
      -- for i = #opts.left, 1, -1 do
      --   if opts.left[i].title == "Neotest Summary" then
      --     table.remove(opts.left, i)
      --     table.insert(opts.right, {
      --       title = "Neotest Summary",
      --       ft = "neotest-summary",
      --     })
      --   end
      -- end

      opts.options = opts.options or {}
      opts.options["left"] = { size = 40 }
      -- opts.options["buttom"] = { size = 10 }
      opts.options["right"] = { size = 40 }
      -- opts.options["top"] = { size = 10 }
      -- table.insert(opts.options.left, {
      --   size = 50,
      -- })
      -- table.insert(opts.options.buttom, {
      --   size = 10,
      -- })
      -- table.insert(opts.options.right, {
      --   size = 50,
      -- })
      -- table.insert(opts.options.top, {
      --   size = 10,
      -- })

      -- print(vim.inspect(opts.options))
    end,
  },
  {
    "vim-fall/fall.vim",
    dependencies = {
      { "vim-denops/denops.vim" },
    },
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<C-p>", "<cmd>lua require('fzf-lua').git_files()<CR>", { silent = true } },
      { "<leader><space>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true } },
      { ";cb", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { silent = true } },
      { ";f", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      -- { "<leader>/", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      { ";cf", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true } },
      { "<C-O>", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true } },
      { "<leader>xo", "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", desc = "Show diagnostics" },
      { ";gst", "<cmd>lua require('fzf-lua').git_status()<CR>", { silent = true } },
      { "<leader>/", "<cmd>lua require('fzf-lua').blines()<CR>", { silent = true } },
      { "<leader>sk", "<cmd>lua require('fzf-lua').keymaps()<CR>", { silent = true } },
      { "<leader>zo", "<cmd>lua require('fzf-lua').zoxide()<CR>", desc = "change cwd, zoxide list" },
    },
    -- opts = function(_, opts)
    --   local config = require("fzf-lua.config")
    --   local actions = require("fzf-lua.actions")
    --
    --   -- Quickfix
    --   config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
    --   config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
    --   config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
    --   config.defaults.keymap.fzf["ctrl-x"] = "jump"
    --   config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
    --   config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
    --
    --   -- Trouble
    --   if LazyVim.has("trouble.nvim") then
    --     config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
    --   end
    --
    --   -- Toggle root dir / cwd
    --   config.defaults.actions.files["ctrl-r"] = function(_, ctx)
    --     local o = vim.deepcopy(ctx.__call_opts)
    --     o.root = o.root == false
    --     o.cwd = nil
    --     o.buf = ctx.__CTX.bufnr
    --     LazyVim.pick.open(ctx.__INFO.cmd, o)
    --   end
    --   config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
    --   config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")
    --
    --   -- use the same prompt for all
    --   local defaults = require("fzf-lua.profiles.telescope")
    --   local function fix(t)
    --     t.prompt = t.prompt ~= nil and " " or nil
    --     for _, v in pairs(t) do
    --       if type(v) == "table" then
    --         fix(v)
    --       end
    --     end
    --   end
    --   fix(defaults)
    --
    --   local img_previewer ---@type string[]?
    --   for _, v in ipairs({
    --     { cmd = "ueberzug", args = {} },
    --     { cmd = "chafa", args = { "{file}", "--format=symbols" } },
    --     { cmd = "viu", args = { "-b" } },
    --   }) do
    --     if vim.fn.executable(v.cmd) == 1 then
    --       img_previewer = vim.list_extend({ v.cmd }, v.args)
    --       break
    --     end
    --   end
    --
    --   return vim.tbl_deep_extend("force", defaults, {
    --     fzf_colors = true,
    --     fzf_opts = {
    --       ["--no-scrollbar"] = true,
    --     },
    --     defaults = {
    --       -- formatter = "path.filename_first",
    --       formatter = "path.dirname_first",
    --     },
    --     previewers = {
    --       builtin = {
    --         extensions = {
    --           ["png"] = img_previewer,
    --           ["jpg"] = img_previewer,
    --           ["jpeg"] = img_previewer,
    --           ["gif"] = img_previewer,
    --           ["webp"] = img_previewer,
    --         },
    --         ueberzug_scaler = "fit_contain",
    --       },
    --     },
    --     -- Custom LazyVim option to configure vim.ui.select
    --     ui_select = function(fzf_opts, items)
    --       return vim.tbl_deep_extend("force", fzf_opts, {
    --         prompt = " ",
    --         winopts = {
    --           title = " " .. vim.trim((fzf_opts.prompt or "Select"):gsub("%s*:%s*$", "")) .. " ",
    --           title_pos = "center",
    --         },
    --       }, fzf_opts.kind == "codeaction" and {
    --         winopts = {
    --           layout = "vertical",
    --           -- height is number of items minus 15 lines for the preview, with a max of 80% screen height
    --           height = math.floor(math.min(vim.o.lines * 0.8 - 16, #items + 2) + 0.5) + 16,
    --           width = 0.5,
    --           preview = not vim.tbl_isempty(LazyVim.lsp.get_clients({ bufnr = 0, name = "vtsls" })) and {
    --             layout = "vertical",
    --             vertical = "down:15,border-top",
    --             hidden = "hidden",
    --           } or {
    --             layout = "vertical",
    --             vertical = "down:15,border-top",
    --           },
    --         },
    --       } or {
    --         winopts = {
    --           width = 0.5,
    --           -- height is number of items, with a max of 80% screen height
    --           height = math.floor(math.min(vim.o.lines * 0.8, #items + 2) + 0.5),
    --         },
    --       })
    --     end,
    --     winopts = {
    --       width = 0.8,
    --       height = 0.8,
    --       row = 0.5,
    --       col = 0.5,
    --       preview = {
    --         scrollchars = { "┃", "" },
    --       },
    --     },
    --     files = {
    --       cwd_prompt = false,
    --       actions = {
    --         ["alt-i"] = { actions.toggle_ignore },
    --         ["alt-h"] = { actions.toggle_hidden },
    --       },
    --     },
    --     grep = {
    --       actions = {
    --         ["alt-i"] = { actions.toggle_ignore },
    --         ["alt-h"] = { actions.toggle_hidden },
    --       },
    --     },
    --     lsp = {
    --       symbols = {
    --         symbol_hl = function(s)
    --           return "TroubleIcon" .. s
    --         end,
    --         symbol_fmt = function(s)
    --           return s:lower() .. "\t"
    --         end,
    --         child_prefix = false,
    --       },
    --       code_actions = {
    --         previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
    --       },
    --     },
    --   })
    -- end,
  },

  -- like indent-blankline
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          notify = true,
          use_treesitter = true,
          -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
          support_filetypes = {
            "*.svelte",
            "*.ts",
            "*.tsx",
            "*.js",
            "*.jsx",
            "*.html",
            "*.json",
            "*.go",
            "*.c",
            "*.py",
            "*.cpp",
            "*.rb",
            "*.rs",
            "*.h",
            "*.hpp",
            "*.lua",
            "*.vue",
            "*.java",
            "*.cs",
            "*.dart",
          },
          exclude_filetypes = {
            aerial = true,
            dashboard = true,
            help = true,
            lspinfo = true,
            lspsagafinder = true,
            packer = true,
            checkhealth = true,
            man = true,
            mason = true,
            NvimTree = true,
            ["neo-tree"] = true,
            Neotest = true,
            NeotestSummary = true,
            NeotestAttach = true,
            ["neotest"] = true,
            ["neotest-summary"] = true,
            ["neotest-attach"] = true,
            Terminal = true,
            ["terminal"] = true,
            plugin = true,
            lazy = true,
            TelescopePrompt = true,
            fzf = true,
            [""] = true, -- because TelescopePrompt will set a empty ft, so add this.
            alpha = true,
            toggleterm = true,
            sagafinder = true,
            sagaoutline = true,
            better_term = true,
            fugitiveblame = true,
            Trouble = true,
            qf = true,
            Outline = true,
            starter = true,
            NeogitPopup = true,
            NeogitStatus = true,
            DiffviewFiles = true,
            DiffviewFileHistory = true,
            DressingInput = true,
            spectre_panel = true,
            zsh = true,
            sh = true,
            registers = true,
            startuptime = true,
            OverseerList = true,
            Navbuddy = true,
            noice = true,
            notify = true,
            ["dap-repl"] = true,
            saga_codeaction = true,
            sagarename = true,
            cmp_menu = true,
            ["null-ls-info"] = true,
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_arrow = ">",
          },
          style = {
            { fg = "#806d9c" },
            { fg = "#c21f30" }, -- this fg is used to highlight wrong chunk
          },
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
        },

        indent = {
          enable = true,
          use_treesitter = false,
          chars = {
            "│",
          },
          style = {
            { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui") },
          },
        },

        line_num = {
          enable = true,
          use_treesitter = false,
          style = "#806d9c",
        },

        blank = {
          enable = true,
          chars = {
            " ",
          },
          style = {
            vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
          },
        },
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    event = { "UIEnter" },
    keys = {},
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
  },
}
