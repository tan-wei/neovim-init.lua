local M = {
  "Kalidozza-theme/neovim",
  name = "Kalidozza",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kalidozza")
  vim.g.available_colorschemes = available_colorschemes
end

return M
