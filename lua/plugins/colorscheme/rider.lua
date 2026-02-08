local M = {
  "tomstolarczuk/rider.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "rider")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
