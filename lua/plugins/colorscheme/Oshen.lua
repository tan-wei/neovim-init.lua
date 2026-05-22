---@type LazyPluginSpec
local M = {
  "54L1M/Oshen.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "Oshen")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = function()
  require("oshen").setup {
    transparent = false,
  }
end

return M
