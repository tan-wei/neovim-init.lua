local M = {
  "valonmulolli/heap.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "heap")
  table.insert(available_colorschemes, "heap-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
