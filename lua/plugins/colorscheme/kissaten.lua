---@type LazyPluginSpec
local M = {
  "bytebeast/kissaten.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "kissaten-afternoon")
  table.insert(available_colorschemes, "kissaten-evening")
  table.insert(available_colorschemes, "kissaten-midnight")
  table.insert(available_colorschemes, "kissaten-graveyard")
  vim.g.available_colorschemes = available_colorschemes
end

return M
