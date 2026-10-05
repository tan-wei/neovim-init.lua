---@type LazyPluginSpec
local M = {
  "ckolkey/ts-node-action",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.opts = {}

return M
