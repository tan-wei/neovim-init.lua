local M = {
  "savq/melange-nvim",
}

M.init = function()
  vim.g.jellybeans_use_term_italics = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "melange")
  vim.g.available_colorschemes = available_colorschemes
end

return M
