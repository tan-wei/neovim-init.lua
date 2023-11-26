local M = {
  "Shatur/neovim-ayu",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ayu-dark")
  vim.g.available_colorschemes = available_colorschemes
end

return M
