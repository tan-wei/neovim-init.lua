---@type LazyPluginSpec
local M = {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
  },
  lazy = false,
}

M.config = true

return M
