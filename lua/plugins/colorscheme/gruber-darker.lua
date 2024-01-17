local M = {
  "blazkowolf/gruber-darker.nvim",
  lazy = true,
  config = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruber-darker")
  vim.g.available_colorschemes = available_colorschemes
end

return M
