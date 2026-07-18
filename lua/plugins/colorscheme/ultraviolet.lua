---@type LazyPluginSpec
local M = {
  "Zira3l137/ultraviolet.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "ultraviolet")
  vim.g.available_colorschemes = available_colorschemes
end

return M
