local M = {
  "bluz71/vim-moonfly-colors",
}

M.init = function()
  vim.g.moonflyCursorColor = true
  vim.g.moonflyItalics = true
  vim.g.moonflyNormalFloat = true
  vim.g.moonflyTerminalColors = false
  vim.g.moonflyUndercurls = true
  vim.g.moonflyVirtualTextColor = true
  vim.g.moonflyWinSeparator = 1
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "moonfly")
  vim.g.available_colorschemes = available_colorschemes
end

return M
