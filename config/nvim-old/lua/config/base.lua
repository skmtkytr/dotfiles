
vim.scriptencoding = "utf-8"

vim.wo.number = true

vim.api.nvim_create_user_command("Tabn", function(opts)
  vim.cmd("tabnew")
end, {})

-- Reference highlight
-- vim.cmd [[
-- set updatetime=500
-- highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline
-- highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline
-- highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline
-- augroup lsp_document_highlight
--   autocmd!
--   autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
--   autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
-- augroup END
-- ]]
