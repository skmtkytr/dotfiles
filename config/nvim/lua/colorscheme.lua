--[[
--vim.cmd [[
try
  colorscheme iceberg
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

vim.cmd([[colorscheme monokai-pro]])
-- vim.cmd([[colorscheme nightfox]])

-- vim.cmd([[let g:sonokai_style = 'espresso']])
-- vim.cmd([[let g:sonokai_better_performance = 1]])
-- vim.cmd([[colorscheme sonokai]])
