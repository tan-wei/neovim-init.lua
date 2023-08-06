

local M = {
  "bluz71/vim-nightfly-colors",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nightfly")
  vim.g.available_colorschemes = available_colorschemes
end

return M
