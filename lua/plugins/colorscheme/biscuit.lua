local M = {
  "Biscuit-Colorscheme/nvim",
  name = "biscuit",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "biscuit")
  vim.g.available_colorschemes = available_colorschemes
end

return M
