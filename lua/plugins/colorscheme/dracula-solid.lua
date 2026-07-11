---@type LazyPluginSpec
local M = {
  "https://codeberg.org/brargenzilian/darcula-solid.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "darcula-solid")
  vim.g.available_colorschemes = available_colorschemes
end

return M
