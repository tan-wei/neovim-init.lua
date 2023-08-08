local M = {
  "ramojus/mellifluous.nvim",
}

M.init = function()
  vim.g.jellybeans_use_term_italics = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mellifluous")
  vim.g.available_colorschemes = available_colorschemes
end

return M
