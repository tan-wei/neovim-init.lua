---@type LazyPluginSpec
local M = {
  "jblandonsv/the-little-prince-themes.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "littleprince")
  table.insert(available_colorschemes, "littleprince-fox")
  table.insert(available_colorschemes, "littleprince-rose")
  table.insert(available_colorschemes, "littleprince-sheep")
  vim.g.available_colorschemes = available_colorschemes
end

return M
