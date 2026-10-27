---@type LazyPluginSpec
local M = {
  "bytebeast/winteriscoming.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "winterisoming-blue")
  table.insert(available_colorschemes, "winterisoming-black")
  vim.g.available_colorschemes = available_colorschemes
end

M.config = true

return M
