local M = {
  "mizlan/iswap.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = { "ISwap", "ISwapWith", "ISwapNode", "ISwapNodeWith", "IMove" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
