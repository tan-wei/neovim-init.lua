local M = {
  "ellisonleao/gruvbox.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruvbox")
  vim.g.available_colorschemes = available_colorschemes
end

return M
