---@type LazyPluginSpec
local M = {
  "ryanjayleyva/cutiepro.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "cutiepro")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
