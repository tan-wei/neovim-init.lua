local M = {
  "reobin/olive-crt.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "olive-crt")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {}

return M
