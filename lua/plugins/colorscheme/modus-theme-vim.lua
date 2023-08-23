local M = {
  "ishan9299/modus-theme-vim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "modus-vivendi")
  vim.g.available_colorschemes = available_colorschemes
end

return M
