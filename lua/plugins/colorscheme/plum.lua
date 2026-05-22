---@type LazyPluginSpec
local M = {
  "takeshid/plum.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "plum")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  variant = "dark",
}

return M
