local M = {
  "folke/tokyonight.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tokyonight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
