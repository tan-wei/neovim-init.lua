local M = {
  "cshuaimin/ssr.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  event = { "VeryLazy" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
