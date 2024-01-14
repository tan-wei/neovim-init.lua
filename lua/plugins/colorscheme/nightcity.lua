local M = {
  "cryptomilk/nightcity.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "nightcity")
  vim.g.available_colorschemes = available_colorschemes
end

return M