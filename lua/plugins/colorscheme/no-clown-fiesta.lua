local M = {
  "aktersnurra/no-clown-fiesta.nvim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "no-clown-fiesta")
  vim.g.available_colorschemes = available_colorschemes
end

return M