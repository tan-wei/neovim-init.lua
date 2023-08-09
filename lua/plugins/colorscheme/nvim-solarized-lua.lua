
local M = {
  "ishan9299/nvim-solarized-lua",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "solarized")
  table.insert(available_colorschemes, "solarized-high")
  table.insert(available_colorschemes, "solarized-flat")
  vim.g.available_colorschemes = available_colorschemes
end

return M
