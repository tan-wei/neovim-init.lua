local M = {
  "phha/zenburn.nvim",
  lazy = true,
  config = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zenburn")
  vim.g.available_colorschemes = available_colorschemes
end

return M
