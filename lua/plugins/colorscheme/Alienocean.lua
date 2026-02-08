local M = {
  "Pair-of-dice/Alienocean.nvim",
  dependencies = {
    "Pair-of-dice/Alienocean-lualine",
  },
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "Alienocean")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
