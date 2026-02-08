local M = {
  "Old-Farmer/noctis-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "noctis")
  table.insert(available_colorschemes, "noctis-vscode")
  table.insert(available_colorschemes, "noctis-azureus")
  table.insert(available_colorschemes, "noctis-bordo")
  table.insert(available_colorschemes, "noctis-obscuro")
  table.insert(available_colorschemes, "noctis-sereno")
  table.insert(available_colorschemes, "noctis-uva")
  table.insert(available_colorschemes, "noctis-viola")
  table.insert(available_colorschemes, "noctis-minimus")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("noctis").setup()
end

return M
