---@type LazyPluginSpec
local M = {
  "ernesxavier/biomes.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "biomes-deep_dark")
  table.insert(available_colorschemes, "biomes-end")
  table.insert(available_colorschemes, "biomes-nether")
  vim.g.available_colorschemes = available_colorschemes
end

return M
