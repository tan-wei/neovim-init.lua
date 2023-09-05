local M = {
  "marko-cerovac/material.nvim",
  lazy = true,
}

M.init = function()
  vim.g.material_style = "deep ocean"
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "material")
  vim.g.available_colorschemes = available_colorschemes
end

return M
