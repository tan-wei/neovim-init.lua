local M = {
  "folke/tokyonight.nvim",
}

M.init = function()
  vim.g.available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(vim.g.available_colorschemes, "tokyonight")
end

return M
