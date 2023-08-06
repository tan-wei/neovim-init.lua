local M = {
  "olimorris/onedarkpro.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "onedark_dark")
  table.insert(available_colorschemes, "onedark_vivid")
  vim.g.available_colorschemes = available_colorschemes
end

return M
