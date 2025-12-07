local M = {
  "Kaikacy/Lemons.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "lemons")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("lemons").setup()
end

return M
