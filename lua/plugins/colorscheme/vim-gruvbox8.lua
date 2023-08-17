local M = {
  "lifepillar/vim-gruvbox8",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "gruvbox8")
  vim.g.available_colorschemes = available_colorschemes
end

return M

