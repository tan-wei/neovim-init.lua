local M = {
  "2nthony/vitesse.nvim",
  dependencies = {
    "tjdevries/colorbuddy.nvim",
  },
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "vitesse")
  vim.g.available_colorschemes = available_colorschemes
end

return M
