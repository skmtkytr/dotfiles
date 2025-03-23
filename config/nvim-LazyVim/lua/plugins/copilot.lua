-- copilot plugins

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    keys = {
      -- Quick chat with Copilot
      {
        "<leader>ccq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      copilot_node_command = vim.fn.expand("$HOME") .. "/.local/share/mise/installs/node/latest/bin/node",
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- provider = "ollama",
      provider = "copilot",
      -- provider = "claude",
      -- provider = "openai",
      auto_suggestions_provider = "copilot",
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        enable_cursor_planning_mode = true, -- enable cursor planning mode!
      },
      windows = {
        position = "right",
        width = 30,
        sidebar_header = {
          align = "center",
          rounded = false,
        },
        ask = {
          floating = true,
          start_insert = true,
          border = "rounded",
        },
      },
      file_selector = {
        --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string | fun(params: avante.file_selector.IParams|nil): nil
        provider = "fzf",
        -- Options override for custom providers
        provider_opts = {},
      },
      -- providers-setting
      ollama = {
        model = "phi4",
      },
      claude = {
        model = "claude-3-5-sonnet-20241022", -- $3/$15, maxtokens=8000
        -- model = "claude-3-opus-20240229",  -- $15/$75
        -- model = "claude-3-haiku-20240307", -- $0.25/1.25
        max_tokens = 8000,
      },
      copilot = {
        -- model = "gpt-4o-2024-05-13",
        -- model = "claude-3-5-sonnet-20240620", -- $3/$15, maxtokens=8000
        -- model = "claude-3.5-sonnet", -- $3/$15, maxtokens=8000
        model = "claude-3.7-sonnet", -- $3/$15, maxtokens=8000
        -- model = "gpt-4o-mini",
        max_tokens = 8000,
      },
      openai = {
        model = "gpt-4o", -- $2.5/$10
        -- model = "gpt-4o-mini", -- $0.15/$0.60
        max_tokens = 8000,
      },
    },

    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>cpc", "<Cmd>CodeCompanionChat Toggle<CR>", mode = { "n" } },
      { "<leader>cpc", "<Cmd>CodeCompanionChat<CR>", mode = { "v" } },
      { "<leader>cpa", "<Cmd>CodeCompanionActions<CR>", mode = { "n", "x" } },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "phi4",
                -- default = "codellama:7b",
              },
            },
          })
        end,
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                -- default = "gpt-4o-2024-05-13",
                default = "claude-3.5-sonnet", -- $3/$15, maxtokens=8000
                -- default = "claude-3-5-sonnet-20240620", -- $3/$15, maxtokens=8000
                -- default = "claude-3-5-sonnet", -- $3/$15, maxtokens=8000
                -- default = "gpt-4o-mini",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          -- adapter = "anthropic",
          adapter = "copilot",
          slash_commands = {
            ["buffer"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["file"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["workspace"] = {
              opts = {
                provider = "snacks",
              },
            },
          },
        },
        inline = {
          adapter = "copilot",
        },
        agent = {
          -- adapter = "openai",
          adapter = "copilot",
        },
      },
      opts = {
        language = "Japanese",
      },
    },
  },
}
