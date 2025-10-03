local M = {
  "talha-akram/noctis.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "noctis")
  table.insert(available_colorschemes, "noctis_bordo")
  table.insert(available_colorschemes, "noctis_viola")
  table.insert(available_colorschemes, "noctis_uva")
  table.insert(available_colorschemes, "noctis_obscuro")
  table.insert(available_colorschemes, "noctis_azureus")
  table.insert(available_colorschemes, "noctis_minimus")
  vim.g.available_colorschemes = available_colorschemes
end

return M
