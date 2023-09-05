local M = {
  "whatyouhide/vim-gotham",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gotham256")
  vim.g.available_colorschemes = available_colorschemes
end

return M
