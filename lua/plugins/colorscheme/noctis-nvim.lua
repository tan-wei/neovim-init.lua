local M = {
  "Old-Farmer/noctis-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "noctis")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("noctis").setup()
end

return M
