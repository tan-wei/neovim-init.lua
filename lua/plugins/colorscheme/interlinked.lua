---@type LazyPluginSpec
local M = {
  "daaanny90/interlinked.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "interlinked")
  vim.g.available_colorschemes = available_colorschemes
end

M.opts = {
  bold_keyowrds = true,
}

return M
