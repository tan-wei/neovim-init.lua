local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "catppuccin")
  vim.g.available_colorschemes = available_colorschemes
end

return M
