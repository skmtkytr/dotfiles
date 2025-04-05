-- eazymotion plugins
return {
  {
    -- "hadronized/hop.nvim",
    "smoka7/hop.nvim",
    version = "*",
    lazy = true,
    keys = {
      {
        "f",
        "<cmd>lua require('hop').hint_char2({ current_line_only = false })<CR>",
        desc = "start hop",
        mode = { "n", "v" },
        { silent = true },
      },
      {
        "F",
        "<cmd>lua require('hop').hint_char2({ direction = require('hop.hint').HintDirection.AFTER_CURSOR, current_line_only = false })<CR>",
        desc = "start hop AFTER_CURSOR",
        { silent = true },
      },
    },
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    end,
  },
}
