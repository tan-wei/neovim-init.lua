local M = {
  "0xleodevv/oc-2.nvim",
  lazy = true,
}

M.config = true

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "oc-2")
  table.insert(available_colorschemes, "oc-2-noir")
  vim.g.available_colorschemes = available_colorschemes
end

return M
