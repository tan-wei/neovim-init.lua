local M = {
  "numToStr/Sakura.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "sakura")
  vim.g.available_colorschemes = available_colorschemes
end

return M