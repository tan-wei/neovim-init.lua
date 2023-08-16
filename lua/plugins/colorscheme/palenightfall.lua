local M = {
  "JoosepAlviste/palenightfall.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "palenightfall")
  vim.g.available_colorschemes = available_colorschemes
end

return M
