local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  lazy = true,
}

-- TODO: This plugin should write more configurations
M.config = true

return M
