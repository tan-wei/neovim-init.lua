---@type LazyPluginSpec
local M = {
  "Bekaboo/dropbar.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  event = "VeryLazy",
}

M.config = true

return M
