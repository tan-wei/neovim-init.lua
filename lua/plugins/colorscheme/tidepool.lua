---@type LazyPluginSpec
local M = {
  "rashedint32/tidepool.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "tidepool")
  vim.g.available_colorschemes = available_colorschemes
end

return M
