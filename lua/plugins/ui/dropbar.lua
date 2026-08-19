---@type LazyPluginSpec
local M = {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
}

M.config = true

return M
