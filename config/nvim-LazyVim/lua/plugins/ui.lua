-- ui settings

return {
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
        ignore_filetypes = { "NvimTree", "TelescopePrompt" },
      })
    end,
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
      table.remove(opts.left, 2)

      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Neotest Summary",
        ft = "neotest-summary",
      })

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

  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<C-p>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true } },
      { ";cb", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { silent = true } },
      { ";f", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      { "<leader>/", "<cmd>lua require('fzf-lua').live_grep_native()<CR>", { silent = true } },
      { ";cf", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true } },
      { "<C-O>", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true } },
      { "<leader>xo", "<cmd>lua require('fzf-lua').lsp_document_diagnostics()<CR>", desc = "Show diagnostics" },
      { ";gst", "<cmd>lua require('fzf-lua').git_status()<CR>", { silent = true } },
      { "<leader>/", "<cmd>lua require('fzf-lua').blines()<CR>", { silent = true } },
      { "<leader>sk", "<cmd>lua require('fzf-lua').keymaps()<CR>", { silent = true } },
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({
        { "telescope" },
        files = {
          fd_opts = "-I --color=never --type f --hidden --follow --exclude .git",
        },
        -- fzf_opts = function()
        --   local opts = { ["--no-separator"] = false }
        --   return opts
        -- end,
      })
    end,
  },

  -- like indent-blankline
  {
    "shellRaining/hlchunk.nvim",
    -- enabled = false,
    event = { "UIEnter" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          notify = true,
          use_treesitter = true,
          -- details about support_filetypes and exclude_filetypes in https://github.com/shellRaining/hlchunk.nvim/blob/main/lua/hlchunk/utils/filetype.lua
          support_filetypes = {
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
            ["neotest-summary"] = true,
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
