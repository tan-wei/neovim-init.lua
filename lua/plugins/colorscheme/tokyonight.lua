local M = {
  "folke/tokyonight.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tokyonight")
  table.insert(available_colorschemes, "tokyonight-storm")
  table.insert(available_colorschemes, "tokyonight-night")
  table.insert(available_colorschemes, "tokyonight-moon")
  vim.g.available_colorschemes = available_colorschemes
end

return M
