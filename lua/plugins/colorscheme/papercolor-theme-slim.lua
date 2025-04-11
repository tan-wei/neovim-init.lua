local M = {
  "pappasam/papercolor-theme-slim",
  lazy = true,
}

M.init = function()
  vim.g.one_allow_italics = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "PaperColorSlim")
  vim.g.available_colorschemes = available_colorschemes
end

return M
