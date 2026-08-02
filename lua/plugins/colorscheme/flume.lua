---@type LazyPluginSpec
local M = {
  "mitander/flume.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "flume-dusk")
  table.insert(available_colorschemes, "flume-mira")
  vim.g.available_colorschemes = available_colorschemes
end

return M
