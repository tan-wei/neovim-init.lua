local M = {
  "overcache/NeoSolarized",
}

M.init = function()
  vim.g.neosolarized_contrast = "normal"
  vim.g.neosolarized_visibility = "normal"
  vim.g.neosolarized_vertSplitBgTrans = 1
  vim.g.neosolarized_bold = 1
  vim.g.neosolarized_underline = 1
  vim.g.neosolarized_italic = 1
  vim.g.neosolarized_termBoldAsBright = 1

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "NeoSolarized")
  vim.g.available_colorschemes = available_colorschemes
end

return M
