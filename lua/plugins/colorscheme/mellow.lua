local M = {
  "kvrohit/mellow.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mellow")
  vim.g.available_colorschemes = available_colorschemes
end

return M
