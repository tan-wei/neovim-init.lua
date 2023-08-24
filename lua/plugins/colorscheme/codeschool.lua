local M = {
  "adisen99/codeschool.nvim",
}

M.init = function()
  vim.g.codeschool_contrast_dark = "hard"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "codeschool")
  vim.g.available_colorschemes = available_colorschemes
end

return M
