---@type LazyPluginSpec
local M = {
  -- "antosha417/nvim-lsp-file-operations",
  "DrKJeff16/nvim-lsp-file-operations", -- NOTE: Use this fork to solve issues
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-tree.lua",
  },
  enabled = false,
}

M.config = true

return M
