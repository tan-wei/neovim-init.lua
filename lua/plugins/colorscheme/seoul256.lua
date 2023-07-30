local M = {
  "junegunn/seoul256.vim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "seoul256")
  vim.g.available_colorschemes = available_colorschemes
end

return M
