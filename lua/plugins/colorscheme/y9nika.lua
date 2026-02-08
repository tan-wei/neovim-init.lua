local M = {
  "y9san9/y9nika.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "y9nika")
  table.insert(available_colorschemes, "y9nika-solar")
  table.insert(available_colorschemes, "y9nika-contrast")
  table.insert(available_colorschemes, "y9nika-less")
  table.insert(available_colorschemes, "y9nika-pickme")
  table.insert(available_colorschemes, "y9nika-coffee")
  table.insert(available_colorschemes, "y9nika-gruber")
  vim.g.available_colorschemes = available_colorschemes
end

return M
