local M = {
  "wesleimp/min-theme.nvim",
  name = "min-dark",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "min-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
