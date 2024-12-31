local M = {
  "rebelot/kanagawa.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kanagawa")
  table.insert(available_colorschemes, "kanagawa-wave")
  table.insert(available_colorschemes, "kanagawa-dragon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
