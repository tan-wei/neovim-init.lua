local M = {
  "qaptoR-nvim/chocolatier.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "chocolatier")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
