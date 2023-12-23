local M = {
  "mellow-theme/mellow.nvim",
  lazy = true,
}

M.init = function()
  vim.g.mellow_italic_comments = true
  vim.g.mellow_italic_keywords = true
  vim.g.mellow_italic_booleans = true
  vim.g.mellow_italic_functions = true
  vim.g.mellow_italic_variables = true
  vim.g.mellow_bold_comments = true
  vim.g.mellow_bold_keywords = true
  vim.g.mellow_bold_booleans = true
  vim.g.mellow_bold_functions = true
  vim.g.mellow_bold_variables = true
  vim.g.mellow_transparent = false
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mellow")
  vim.g.available_colorschemes = available_colorschemes
end

return M
