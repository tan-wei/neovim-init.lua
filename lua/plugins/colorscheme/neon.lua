local M = {
  "rafamadriz/neon",
  lazy = true,
}

M.init = function()
  vim.g.neon_style = "dark"

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "neon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
