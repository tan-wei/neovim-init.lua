---@type LazyPluginSpec
local M = {
  "marekh19/meowsoot.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "meowsoot")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  plugins = {
    all = true,
  },
}

return M
