local M = {
  "Wansmer/sibling-swap.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = "VeryLazy",
}

-- TODO: This plugin should write more configurations
M.config = true

return M
