---@type LazyPluginSpec
local M = {
  "Wansmer/sibling-swap.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

M.opts = {
  use_default_keymaps = false,
}

M.keys = require("user.keymap.registry").lazy_keys "sibling-swap.nvim"

return M
