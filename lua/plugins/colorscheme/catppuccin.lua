local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "catppuccin")
  table.insert(available_colorschemes, "catppuccin-frappe")
  table.insert(available_colorschemes, "catppuccin-macchiato")
  table.insert(available_colorschemes, "catppuccin-mocha")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
