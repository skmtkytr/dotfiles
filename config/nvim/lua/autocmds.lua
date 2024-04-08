-- Desc: Autocommands for Neotree
vim.api.nvim_create_augroup("neotree", {})
vim.api.nvim_create_autocmd("UiEnter", {
  desc = "Open Neotree automatically",
  group = "neotree",
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd "Neotree toggle"
    end
  end,
})


-- local function is_neotree_open()
-- 	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
-- 		if vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'ft') == 'neo-tree' then
-- 			return require'bufferline.api'.set_offset(35, 'FileTree')
-- 		end
-- 	end
-- 	return require 'bufferline.api'.set_offset(0)
-- end
--
-- vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufWipeout' }, {
-- 	pattern = '*',
-- 	callback = function()
-- 		is_neotree_open()
-- 	end
-- })

-- -- Does work
-- vim.api.nvim_create_autocmd('BufWinEnter', {
--   callback = function(tbl)
--     if vim.bo[tbl.buf].filetype == 'NvimTree' then
--       require'bufferline.api'.set_offset(31, 'FileTree')
--     end
--   end
-- })
--
-- vim.api.nvim_create_autocmd('BufWipeout', {
--   callback = function(tbl)
--     if vim.bo[tbl.buf].filetype == 'NvimTree' then
--       require'bufferline.api'.set_offset(0)
--     end
--   end
-- })
