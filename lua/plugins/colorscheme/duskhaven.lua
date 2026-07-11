---@type LazyPluginSpec
local M = {
  "kbraggins/duskhaven.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "duskhaven")
  vim.g.available_colorschemes = available_colorschemes
end

return M
