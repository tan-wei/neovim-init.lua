local M = {
  "myypo/borrowed.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "mayu")
  table.insert(available_colorschemes, "shin")
  vim.g.available_colorschemes = available_colorschemes
end

return M
