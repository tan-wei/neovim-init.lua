local M = {
  "drewxs/ash.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ash")
  vim.g.available_colorschemes = available_colorschemes
end

return M
