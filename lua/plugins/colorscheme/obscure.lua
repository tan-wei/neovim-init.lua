local M = {
  "mslvx/obscure.nvim",
  lazy = true,
}

M.config = true

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "obscure")
  vim.g.available_colorschemes = available_colorschemes
end

return M
