local M = {
  "altercation/vim-colors-solarized",
}

M.init = function()
  vim.g.solarized_termcolors = 256
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "solarized")
  vim.g.available_colorschemes = available_colorschemes
end

return M
