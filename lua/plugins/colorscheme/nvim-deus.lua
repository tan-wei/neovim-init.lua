local M = {
  "theniceboy/nvim-deus",
  lazy = true,
}

M.init = function()
  vim.g.deus_termcolors = 256

  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "deus")
  vim.g.available_colorschemes = available_colorschemes
end

return M
