local M = {
  "joselrodrigues/cursor-dark-midnight.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cursor-dark-midnight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
