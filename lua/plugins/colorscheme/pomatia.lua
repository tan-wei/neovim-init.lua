local M = {
  "aliqyan-21/pomatia.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "pomatia")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
