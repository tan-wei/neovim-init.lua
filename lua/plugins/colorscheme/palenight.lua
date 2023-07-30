local M = {
  "drewtempelmeyer/palenight.vim",
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "palenight")
  vim.g.available_colorschemes = available_colorschemes
end

return M
