local M = {
  "rose-pine/neovim",
  name = "rose-pine",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "rose-pine")
  vim.g.available_colorschemes = available_colorschemes
end

return M
