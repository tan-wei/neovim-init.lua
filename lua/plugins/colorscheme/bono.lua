---@type LazyPluginSpec
local M = {
  "aadielpr/bono.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "bono")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  variant = "espresso",
}

return M
