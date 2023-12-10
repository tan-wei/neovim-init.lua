local M = {
  "j-morano/buffer_manager.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  event = { "BufEnter" },
}

-- TODO: This plugin should write more configurations
M.config = true

return M
