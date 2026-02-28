local M = {
  "kurund/atomic.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "atomic")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  style = "default", -- "dark"
}

return M
