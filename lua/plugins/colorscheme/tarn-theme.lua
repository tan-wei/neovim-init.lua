---@type LazyPluginSpec
local M = {
  "harehare/tarn-theme",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tarn")
  vim.g.available_colorschemes = available_colorschemes
end

return M
