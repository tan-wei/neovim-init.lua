---@type LazyPluginSpec
local M = {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
}

M.opts = {
  use_default_keymaps = false,
}

return M
