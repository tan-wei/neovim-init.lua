---@type LazyPluginSpec
local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  lazy = true,
}

M.config = function()
  require("dapui").setup {}
end

return M
