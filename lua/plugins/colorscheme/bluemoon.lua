local M = {
  "kyazdani42/blue-moon",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "blue-moon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
