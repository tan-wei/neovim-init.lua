---@type LazyPluginSpec
local M = {
  "MrDwarf7/lazyjui.nvim",
  cmd = { "LazyJui" },
  dependencies = { "nvim-lua/plenary.nvim" },
}

M.opts = {
  cmd = { "jjui" },
  height = 0.9,
  width = 0.9,
  winblend = 0,
  use_default_keymaps = false,
}

return M
