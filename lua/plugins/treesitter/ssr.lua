---@type LazyPluginSpec
local M = {
  "cshuaimin/ssr.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "VeryLazy" },
}

M.config = true

return M
