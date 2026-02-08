local M = {
  "LuxVim/lux.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "lux-vesper")
  table.insert(available_colorschemes, "lux-umbra")
  table.insert(available_colorschemes, "lux-aurora")
  vim.g.available_colorschemes = available_colorschemes
end

return M
