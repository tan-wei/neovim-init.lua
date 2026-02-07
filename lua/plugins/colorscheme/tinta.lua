local M = {
  "arxngr/tinta.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tinta")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  transparent = false,
  palette = "tinta-darker"
}

return M
