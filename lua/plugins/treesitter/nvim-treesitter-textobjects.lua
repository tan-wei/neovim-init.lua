---@type LazyPluginSpec
local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.opts = {
  textobjects = {
    move = {
      set_jumps = true,
    },
  },
}

return M
