local M = {
  "jakubkarlicek/molokai-nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "molokai-nvim")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("molokai-nvim").setup()
end

return M
