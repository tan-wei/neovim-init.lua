---@type LazyPluginSpec
local M = {
  "tan-wei/zimablue.nvim",
  lazy = true,
}

M.init = function()
  local available_colorschemes = vim.g.available_colorschemes or {}
  table.insert(available_colorschemes, "zimablue")
  table.insert(available_colorschemes, "zimablue-pool")
  table.insert(available_colorschemes, "zimablue-storm")
  table.insert(available_colorschemes, "zimablue-sunset")
  table.insert(available_colorschemes, "zimablue-volcano")
  vim.g.available_colorschemes = available_colorschemes
end

return M
