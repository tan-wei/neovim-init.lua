local M = {
  "mzlogin/vim-markdown-toc",
}

M.init = function()
  vim.g.vmt_auto_update_on_save = 1
  vim.g.vmt_dont_insert_fence = 0
  vim.g.vmt_cycle_list_item_markers = 1
  vim.g.vmt_list_item_chars = { "*", "-", "+" }
end

return M
