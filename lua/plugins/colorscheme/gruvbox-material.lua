local M = {
  "sainnhe/gruvbox-material",
  lazy = true,
}

M.init = function()
  vim.g.gruvbox_material_background = "soft"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruvbox-material")
  vim.g.available_colorschemes = available_colorschemes
end

return M
