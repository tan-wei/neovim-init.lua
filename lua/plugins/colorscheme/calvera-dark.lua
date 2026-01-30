local M = {
  "niyabits/calvera-dark.nvim",
  lazy = true,
}

M.init = function()
  vim.g.calvera_italic_keywords = false
  vim.g.calvera_borders = true
  vim.g.calvera_contrast = true
  vim.g.calvera_hide_eob = true
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "calvera")
  vim.g.available_colorschemes = available_colorschemes
end

return M
