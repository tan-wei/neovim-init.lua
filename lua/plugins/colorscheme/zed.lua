---@type LazyPluginSpec
local M = {
  "daaanny90/zed.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zed-ayu-mirage")
  table.insert(available_colorschemes, "zed-blueprint")
  table.insert(available_colorschemes, "zed-graph-paper")
  table.insert(available_colorschemes, "zed-macos-classic-dark")
  table.insert(available_colorschemes, "zed-one-dark")
  table.insert(available_colorschemes, "zed-oscilloscope")
  vim.g.available_colorschemes = available_colorschemes
end

return M
