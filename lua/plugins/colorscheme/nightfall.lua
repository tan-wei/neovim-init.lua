---@type LazyPluginSpec
local M = {
  "2giosangmitom/nightfall.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "deeper-night")
  table.insert(available_colorschemes, "maron")
  table.insert(available_colorschemes, "nightfall")
  vim.g.available_colorschemes = available_colorschemes
end

return M
